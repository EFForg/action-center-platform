namespace :ahoy do
  desc "Fix name for view events"
  task fix_views: :environment do
    Ahoy::Event.where("properties ->> 'actionType' = 'view'").update_all(name: "View")
  end

  task fix_action_page_ids: :environment do
    Ahoy::Event.where(action_page_id: nil).each do |e|
      puts "Updating event id: #{e.id}"
      e.update(action_page_id: e.properties["actionPageId"])
    end
  end
end
