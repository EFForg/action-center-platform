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
    sig_dups = Signature.group(:email, :petition_id).count.map do |data, count|
      data if count > 1
    end.compact
    sig_dups.each do |email, petition_id|
      Signature.where(petition_id: petition_id, email: email)
        .order(:created_at).drop(1).map(&:delete)
    end

    sub_dups = Subscription.group(:email, :partner_id).count.map do |data, count|
      data if count > 1
    end.compact
    sub_dups.each do |email, partner_id|
      Subscription.where(partner_id: partner_id, email: email)
                  .order(:created_at).drop(1).map(&:delete)
    end
  end
end
