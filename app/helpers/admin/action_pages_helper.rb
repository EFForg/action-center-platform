module Admin
  module ActionPagesHelper
    def call_campaign_options_for_select
      if CallTool.enabled?
        CallTool.campaigns.map do |campaign|
          ["#{campaign['name']} (#{campaign['status']})", campaign["id"]]
        end.sort_by(&:last).reverse
      else
        []
      end
    rescue SystemCallError, RestClient::Exception
      []
    end

    def congress_member_options_for_select(campaign)
      selected = (campaign.target_bioguide_ids || "").split(/\s*,\s*/)

      state_names = Places.us_state_codes.invert

      congressional_bioguides = []
      grouped_reps = CongressMember.all.group_by do |rep|
        congressional_bioguides << rep.bioguide_id
        state_names[rep.state]
      end

      grouped_reps.each do |state, state_reps|
        grouped_reps[state] = state_reps.sort_by(&:last_name).map do |rep|
          label = "#{rep.full_name} (#{rep.bioguide_id})"
          [label, rep.bioguide_id]
        end
      end

      grouped_reps = grouped_reps.keys.sort.map { |k| [k, grouped_reps[k]] }

      non_congressional_bioguides = []
      CongressMessageCampaign.targets_bioguide_ids.pluck(:target_bioguide_ids).each do |targets|
        non_congressional_bioguides.concat(targets.split(/\s*,\s*/) - congressional_bioguides)
      end

      if non_congressional_bioguides.present?
        grouped_reps.unshift(["Non-congressional", non_congressional_bioguides.sort])
      end

      grouped_options_for_select(grouped_reps, selected)
    end
  end
end
