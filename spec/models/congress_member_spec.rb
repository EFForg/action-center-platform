require "rails_helper"

describe CongressMember do
  let(:legislators) do
    end_date = (Time.now + 1.year).strftime("%Y-%m-%d")
    [
      CongressMember.new(
        "bioguide_id" => "A000001",
        "term_end" => end_date,
        "full_name" => "Alice Mars",
        "first_name" => "Alice",
        "last_name" => "Mars",
        "twitter_id" => "AliceMars"
      ),
      CongressMember.new(
        "bioguide_id" => "B000001",
        "term_end" => end_date,
        "full_name" => "Bob Saturn",
        "first_name" => "Bob",
        "last_name" => "Saturn",
        "twitter_id" => "BobSaturn"
      )
    ]
  end

  describe ".bioguide_map" do
    it "should return a hash mapping bioguide_id to info about a legislator" do
      expect(CongressMember).to receive(:all).and_return(legislators)

      map = CongressMember.bioguide_map
      legislators.each do |legislator|
        member = map[legislator.bioguide_id]
        expect(member).to eq(legislator)
      end
    end
  end
end
