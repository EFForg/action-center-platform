require "rails_helper"

describe Signature do
  before(:each) do
    @attr = {
      petition_id: 1,
      first_name: "Save Kittens",
      last_name: "Save kittens in great detail",
      email: "johnsmith@eff.org",
      country_code: "US",
      zipcode: "94109",
      street_address: "815 Eddy Street",
      city: "San Francisco",
      state: "CA",
      anonymous: false
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
    long_zip = @attr.merge(zipcode: "9" * 13)

    expect {
      Signature.create!(long_zip)
    }.to raise_error ActiveRecord::RecordInvalid
  end

  describe ".filter" do
    let(:jon) { Signature.create!(@attr.merge(email: "xx@example.com", first_name: "Jon", last_name: "A")) }
    let(:jan) { Signature.create!(@attr.merge(email: "xy@example.com", first_name: "Jan", last_name: "B")) }
    let(:jeb) { Signature.create!(@attr.merge(email: "wz@example.com", first_name: "Jeb", last_name: "C")) }
    let(:jen) { Signature.create!(@attr.merge(email: "wv@example.com", first_name: "Jen", last_name: "D")) }

    let(:all_signatures) { [jon, jan, jeb, jen] }

    it "should return .all when query is blank" do
      expect(Signature.filter(nil)).to contain_exactly(*all_signatures)
      expect(Signature.filter("")).to contain_exactly(*all_signatures)
      expect(Signature.filter("    \t")).to contain_exactly(*all_signatures)
    end

    it "should return signatures with matching email (case insensitive)" do
      expect(Signature.filter("example.com")).to contain_exactly(*all_signatures)
      expect(Signature.filter("EXAMPLE")).to contain_exactly(*all_signatures)
      expect(Signature.filter("w")).to contain_exactly(jeb, jen)
      expect(Signature.filter("xx")).to contain_exactly(jon)
    end

    it "should return signatures with matching names (case insensitive)" do
      expect(Signature.filter("J")).to contain_exactly(*all_signatures)
      expect(Signature.filter("Jon")).to contain_exactly(jon)
      expect(Signature.filter("Jan B")).to contain_exactly(jan)
      expect(Signature.filter("Jeb c")).to contain_exactly(jeb)
    end
  end
end
