namespace :signatures do
  desc "Fill in US States from zipcodes"
  task :fill_us_states => :environment do
    Signature.where(country_code: 'US').where('zipcode is not NULL').each do |sig|
      if sig.city.blank? and sig.state.blank? and GoingPostal.valid_zipcode?(sig.zipcode, 'US')
        begin
          if city_state = SmartyStreets.get_city_state(sig.zipcode)
            sig.city = city_state['city']
            sig.state = city_state['state']
            sig.save
            puts "Updated: #{sig.inspect}"
          end
        rescue
          puts "Lookup failed for signature #{sig.id}"
        end
      end
    end
  end

  desc "Deduplicate signatures (identified by email) from petitions"
  task deduplicate: :environment do
    dups = Signature.group(:petition_id, :email).having("count(*) > 1")
    dups.pluck(:petition_id, :email).each do |petition_id, email|
      ids = Signature.where(petition_id: petition_id, email: email).order(:created_at).ids
      Signature.where(id: ids[1..-1]).delete_all
    end
  end
end
