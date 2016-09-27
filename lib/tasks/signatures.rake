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
end
