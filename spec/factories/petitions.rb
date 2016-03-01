FactoryGirl.define do
  factory :petition do
    sequence(:title)      { |n| "petition-#{n}" }
    description "A sample Petition"
    goal 100

    after(:create) do |petition|
      FactoryGirl.create(:action_page_with_petition, petition_id: petition.id)
    end
  end

  factory :petition_complete_with_one_hundred_signatures, :parent => :petition do
    after(:create) do |petition|
      100.times { petition.signatures << FactoryGirl.build(:signature, petition_id: petition.id) }
    end
  end

  factory :petition_with_99_signatures_needing_1_more, :parent => :petition do
    after(:create) do |petition|
      99.times { petition.signatures << FactoryGirl.build(:signature, petition_id: petition.id) }
    end
  end

  factory :petition_complete_with_one_thousand_signatures, :parent => :petition do
    after(:create) do |petition|
      1000.times { petition.signatures << FactoryGirl.build(:signature, petition_id: petition.id) }
    end
  end

end
