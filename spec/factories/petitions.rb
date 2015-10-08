FactoryGirl.define do
  factory :petition do
    sequence(:title)      { |n| "petition-#{n}" }
    description "A sample Petition"
    goal 100
  end


  factory :petition_complete_with_one_hundred_signatures, :parent => :petition do
    after(:create) do |petition|
      100.times { petition.signatures << FactoryGirl.build(:signature, petition_id: petition.id) }
    end
  end

end
