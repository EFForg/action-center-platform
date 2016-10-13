require "rails_helper"

describe Congress::Member do
  describe ".bioguide_map" do
    let(:current_legislators) do
      end_date = (Time.now + 1.year).strftime("%Y-%m-%d")
      [
        { "terms" => [{ "start" => "2016-01-01", "end" => end_date }],
          "id" => { "bioguide" => "A000001" },
          "name" => { "official_full" => "Alice Mars" },
          "social" => { "twitter" => "AliceMars" }
        },
        { "terms" => [{ "start" => "2016-01-01", "end" => end_date }],
          "id" => { "bioguide" => "B000001" },
          "name" => { "official_full" => "Bob Saturn" },
          "social" => { "twitter" => "BobSaturn" }
        }
      ]
    end

    let(:historical_legislators) do
      [
        { "terms" => [{ "start" => "2012-01-01", "end" => "2012-01-02" }],
          "id" => { "bioguide" => "C000001" },
          "name" => { "official_full" => "Charlize Mercury" },
          "social" => { "twitter" => "CharlizeMercury" }
        },
        { "terms" => [{ "start" => "2012-01-01", "end" => "2012-01-02" }],
          "id" => { "bioguide" => "D000001" },
          "name" => { "official_full" => "Dave Moon" },
          "social" => { "twitter" => "DaveMoon" }
        }
      ]
    end

    let(:legislators){ current_legislators + historical_legislators }

    before do
      stub_request(:get, %r{legislators-current.yaml}).
        to_return(status: 200, body: current_legislators.to_yaml)

      stub_request(:get, %r{legislators-historical.yaml}).
        to_return(status: 200, body: historical_legislators.to_yaml)

      stub_request(:get, %r{legislators-social-media.yaml}).
        to_return(status: 200, body: legislators.to_yaml)
    end

    it "should fetch sources and return a hash mapping bioguide_id to info about a legislator" do
      map = Congress::Member.bioguide_map
      legislators.each do |legislator|
        member = map[legislator["id"]["bioguide"]]
        expect(member).to be_a(Congress::Member)
        expect(member.name).to eq(legislator["name"]["official_full"])
        expect(member.twitter_id).to eq(legislator["social"]["twitter"])
      end
    end
  end
end
