FactoryGirl.define do
  factory :source_file do
    key "uploaded_files/meh.jpg"

    to_create { |instance| instance.save(validate: false) } # skip before filters
  end
end
