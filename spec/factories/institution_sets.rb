FactoryGirl.define do
  factory :institution_set do
    name "U.S. Colleges and Universities"

    after(:create) do |institution_set|
      10.times { institution_set.institutions << FactoryGirl.build(:institution, institution_set_id: institution_set.id) }
    end
  end
end
