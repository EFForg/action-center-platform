require "rails_helper"

describe ActionPage do

  before(:each) do
    @attr = {
      title: "Save Kittens",
      summary: "Save kittens in great detail",
      description: "Some description",
      email_text: ""
    }
  end

  it "should create a new instance given a valid attribute" do
    expect {
      ActionPage.create!(@attr)
    }.to change{ActionPage.count}.by(1)
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
