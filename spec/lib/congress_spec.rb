require "rails_helper"

describe Congress do
  describe ".bioguide_map" do
    let(:current_legislators) do
      [
        { "terms" => [{ "start" => "2016-01-01" }],
          "id" => { "bioguide" => "A000001" },
          "name" => { "official_full" => "Alice Mars" }
        },
        { "terms" => [{ "start" => "2016-01-01" }],
          "id" => { "bioguide" => "B000001" },
          "name" => { "official_full" => "Bob Saturn" }
        }
      ]
    end

    let(:historical_legislators) do
      [
        { "terms" => [{ "start" => "2012-01-01" }],
          "id" => { "bioguide" => "C000001" },
          "name" => { "official_full" => "Charlize Mercury" }
        },
        { "terms" => [{ "start" => "2012-01-01" }],
          "id" => { "bioguide" => "D000001" },
          "name" => { "official_full" => "Dave Moon" }
        }
      ]
    end

    let(:legislators){ current_legislators + historical_legislators }

    before do
      stub_request(:get, %r{unitedstates/congress-legislators/master/legislators-current.yaml}).
        to_return(status: 200, body: current_legislators.to_yaml)

      stub_request(:get, %r{unitedstates/congress-legislators/master/legislators-historical.yaml}).
        to_return(status: 200, body: historical_legislators.to_yaml)
    end

    it "should fetch sources and return a hash mapping bioguide_id to info about a legislator" do
      map = Congress.bioguide_map
      legislators.each do |legislator|
        expect(map[legislator["id"]["bioguide"]]).to eq(name: legislator["name"]["official_full"])
      end
    end
  end
end
