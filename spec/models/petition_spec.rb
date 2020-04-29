require "rails_helper"

describe Petition do
  before(:each) do
    @attr = {
      title: "Save Kittens",
      description: "Save kittens in great detail",
      goal: 10
    }
  end

  it "should create a new instance given a valid attribute" do
    Petition.create!(@attr)
  end

  it "should output useful CSV files" do
    p = FactoryGirl.create(:petition_complete_with_one_hundred_signatures)
    expected_first_record = "John Doe,#{p.signatures.to_a.first.email},San Francisco,CA,United States of America\n"

    csv = p.signatures.to_presentable_csv

    columns = csv.lines.first
    first_record = csv.lines[1]

    expect(columns).to eq("full_name,email,city,state,country\n")
    expect(first_record).to eq(expected_first_record)
  end
end
