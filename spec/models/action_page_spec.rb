require "rails_helper"

describe ActionPage do

  let(:attr) { FactoryGirl.attributes_for :action_page }

  it "creates a new instance given a valid attribute" do
    expect {
      ActionPage.create!(attr)
    }.to change{ActionPage.count}.by(1)
  end

  it "knows when to redirect from an archived action" do
    action_page = FactoryGirl.build_stubbed :archived_action_page
    expect(action_page.redirect_from_archived_to_active_action?).to be_truthy
  end





  # The test was a no-go because of the ajaxy html requiring nils... and Then
  # changing them from nils to ""???  Needs effeciency review before crashyness review
  # it "should not allow the creation of a model with so few attrs that it would crash the views" do
  #   expect {
  #     ActionPage.create!({ })
  #   }.to raise_exception(ActiveRecord::RecordInvalid)
  #
  #   expect(ActionPage.count).to eq 0
  # end

end
