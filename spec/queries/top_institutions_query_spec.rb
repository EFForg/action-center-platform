require "rails_helper"

describe TopInstitutionsQuery do
  describe ".run" do
    # TODO: rewrite to use action page as the main reference record? the
    # petition is never actually used beyond its ID
    let(:petition) { FactoryBot.create(:local_organizing_petition) }

    def create_university_for(p, **attrs)
      p.action_page.institutions.create(category: "University", **attrs)
    end

    def student_sign(p, institution, **attrs)
      sig = FactoryBot.create(:signature, petition_id: p.id)
      sig.affiliations.create(institution_id: institution.id, **attrs)
    end

    let(:high_rank) { create_university_for(petition, name: "A") }
    let(:mid_rank) { create_university_for(petition, name: "B") }
    let(:low_rank) { create_university_for(petition, name: "C") }

    let(:student) { petition.action_page.affiliation_types.find_or_create_by!(name: "Student") }

    before(:each) do
      100.times { student_sign(petition, high_rank, affiliation_type: student) }
      50.times { student_sign(petition, mid_rank, affiliation_type: student) }
      10.times { student_sign(petition, low_rank, affiliation_type: student) }
    end

    it "should return the top n institutions ordered by number of signatures" do
      expect(
        described_class.run(action_page: petition.action_page, limit: 3)
                       .map(&:id)
      ).to eq([high_rank, mid_rank, low_rank].map(&:id))
    end

    it "allows exclusions from results" do
      expect(
        described_class.run(action_page: petition.action_page,
                            limit: 3,
                            exclude: [low_rank])
                       .map(&:id)
      ).to eq([high_rank.id, mid_rank.id, high_rank.id - 1])
    end
  end
end
