require "rails_helper"

describe ActionPageFilters do
  it "returns only actions matching the given filters" do
    category = FactoryGirl.create(:category)
    basic = FactoryGirl.create(:action_page)
    category_action = FactoryGirl.create(:action_page,
                                         enable_tweet: true,
                                         category: category)
    draft_old = FactoryGirl.create(:action_page,
                                   enable_tweet: true,
                                   published: false,
                                   created_at: Time.zone.today - 7.days)
    authored_old = FactoryGirl.create(:action_page,
                                      enable_tweet: true,
                                      created_at: Time.zone.today - 7.days,
                                      author: FactoryGirl.create(:user),
                                      category: category)
    new_date_range = "#{Time.zone.today - 3.days} - #{Time.zone.today}"

    result = described_class.run(category: category)
    expect(result).to contain_exactly(category_action, authored_old)

    result = described_class.run(date_range: new_date_range)
    expect(result).to contain_exactly(category_action, basic)

    result = described_class.run(author: authored_old.user_id)
    expect(result).to contain_exactly(authored_old)

    result = described_class.run(type: "tweet", status: "draft")
    expect(result).to contain_exactly(draft_old)
  end

  it "does not filter when values are blank or 'all'" do
    FactoryGirl.create(:action_page)
    FactoryGirl.create(:action_page, enable_tweet: true,
                       category: FactoryGirl.create(:category))
    FactoryGirl.create(:action_page, enable_tweet: true, published: false,
                       created_at: Time.zone.today - 7.days)
    result = described_class.run(category: "all", type: "", status: "all",
                                   author: "", date_range: "")
    expect(result.size).to eq(3)
  end

  it "raises an ArgumentError when an invalid filter is given" do
    expect { described_class.run(fail: "value") }.to raise_error(ArgumentError)
  end
end
