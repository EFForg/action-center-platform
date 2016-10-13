module Congress
  class Member < OpenStruct
    def self.bioguide_map
      @members ||= {}.tap do |map|
        legislator_sources.each do |repo|
          data = RestClient.get(repo)
          YAML.load(data).each do |info|
            term = info["terms"].last
            next if term["start"] < "2011-01-01" # don't get too historical

            map[info["id"]["bioguide"]] = Member.new(
              name:        info["name"]["official_full"],
              first_name:  info["name"]["first"],
              last_name:   info["name"]["last"],
              bioguide_id: info["id"]["bioguide"],
              phone:       term["phone"],
              current:     Time.now.strftime("%Y-%m-%d") <= term["end"],
              chamber:     term["type"] == "sen" ? "senate" : "house",
              state:       term["state"],
              district:    term["district"].try(:to_s)
            )
          end

          legislator_social_media_sources.each do |repo|
            data = RestClient.get(repo)
            YAML.load(data).each do |info|
              next unless member = map[info["id"]["bioguide"]]
              if twitter_id = info["social"]["twitter"]
                member.twitter_id = twitter_id
              end
            end
          end
        end
      end
    end

    def self.all
      bioguide_map.values
    end

    def self.current
      all.select(&:current?)
    end

    def self.find_by(street:, zipcode:)
      state, district = SmartyStreets.get_congressional_district(street, zipcode)
      if state && district
        find_by_district(state, district)
      end
    end

    def current?; current; end
    def senate?; chamber == "senate"; end
    def house?; chamber == "house"; end

    def as_json(*args)
      to_h.slice(:name, :first_name, :last_name, :bioguide_id, :chamber).as_json(*args)
    end

    protected

    def self.find_by_district(state, district)
      current.select do |member|
        member.state == state && (member.senate? || member.district == district)
      end
    end

    def self.legislator_sources
      [
        "https://rawgit.com/unitedstates/congress-legislators/master/legislators-current.yaml",
        "https://rawgit.com/unitedstates/congress-legislators/master/legislators-historical.yaml"
      ]
    end

    def self.legislator_social_media_sources
      [
        "https://raw.githubusercontent.com/unitedstates/congress-legislators/master/legislators-social-media.yaml"
      ]
    end
  end
end
