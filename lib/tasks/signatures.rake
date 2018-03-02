namespace :signatures do
  desc "Fill in US States from zipcodes"
  task fill_us_states: :environment do
    Signature.where(country_code: "US").where("zipcode is not NULL").each do |sig|
      if sig.city.blank? and sig.state.blank? and GoingPostal.valid_zipcode?(sig.zipcode, "US")
        begin
          if city_state = SmartyStreets.get_city_state(sig.zipcode)
            sig.city = city_state["city"]
            sig.state = city_state["state"]
            sig.save
            puts "Updated: #{sig.inspect}"
          end
        rescue
          puts "Lookup failed for signature #{sig.id}"
        end
      end
    end
  end

  desc "Deduplicate signatures from petitions and subscriptions from partners"
  task deduplicate: :environment do
    sig_dups = Signature.group(:petition_id, :email).having("count(*) > 1")
    sig_dups.pluck(:petition_id, :email).each do |petition_id, email|
      ids = Signature.where(petition_id: petition_id, email: email).order(:created_at).ids
      Signature.where(id: ids[1..-1]).delete_all
    end

    sub_dups = Subscription.group(:partner_id, :email).having("count(*) > 1")
    sub_dups.pluck(:partner_id, :email).each do |partner_id, email|
      Subscription.where(partner_id: partner_id, email: email)
        .order(:created_at)[1..-1].each(&:delete)
    end
  end
end
