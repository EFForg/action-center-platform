FactoryBot.define do
  factory :source_file do
    sequence(:key) { |n| "#{n}_meh.jpg" }
    file_name { key.split("/").last }
  end
end
