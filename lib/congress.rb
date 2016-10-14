module Congress
  def self.bioguide_map
    @bioguide_map ||= {}.tap do |map|
      sources = [
        "unitedstates/congress-legislators/master/legislators-current.yaml",
        "unitedstates/congress-legislators/master/legislators-historical.yaml"
      ]

      sources.each do |repo|
        data = RestClient.get("https://rawgit.com/#{repo}")

        YAML.load(data).each do |member|
          next if member["terms"].last["start"] < "2011-01-01" # don't get too historical

          map[member["id"]["bioguide"]] = { name: member["name"]["official_full"] }
        end
      end
    end
  end
end
