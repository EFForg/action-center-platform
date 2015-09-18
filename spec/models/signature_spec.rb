require 'spec_helper'

describe Signature do

  before(:each) do
    @attr = {
      :petition_id => 1,
      :first_name => "Save Kittens",
      :last_name => "Save kittens in great detail",
      :email => "johnsmith@eff.org",
      :country_code => "US",
      :zipcode => "94109",
      :street_address => "815 Eddy Street",
      :city => "San Francisco",
      :state => "CA",
      :anonymous => false
    }
  end

  it "should create a new instance given a valid attribute" do
    Signature.create!(@attr)
  end

  it "should reject spammy emails" do
    invalid_email = @attr.merge(email: "a@b")

    expect {
      Signature.create!(invalid_email)
    }.to raise_error ActiveRecord::RecordInvalid
  end

  it "should impose an arbitrary opinion as to whether a string of text may refer to a country" do
    # note: it is my personal belief that there is no such thing as a country/ nation =)
    arbitrarily_invalid_opinion = @attr.merge(country_code: "laserland")

    expect {
      Signature.create!(arbitrarily_invalid_opinion)
    }.to raise_error ActiveRecord::RecordInvalid
  end

  it "should reject long zipcodes" do
    long_zip = @attr.merge(zipcode: "9"*13)

    expect {
      Signature.create!(long_zip)
    }.to raise_error ActiveRecord::RecordInvalid
  end

end
