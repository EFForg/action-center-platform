require "rails_helper"

describe Institution do
  describe ".top" do
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
      expect(petition.action_page.institutions.top(3).to_a).to eq([high_rank, mid_rank, low_rank])
    end

    it "should allow an argument which reorders a certain institution to the front" do
      expect(petition.action_page.institutions.top(3, first: low_rank.id).to_a).to eq([low_rank, high_rank, mid_rank])
    end
  end

  describe ".import" do
    let(:action_page) { FactoryBot.create(:action_page) }
    let(:institution) { FactoryBot.create(:institution) }
    let(:names) do
      ["University of California, Berkeley",
       "University of California, Santa Cruz"]
    end

    it "adds institutions by name" do
      expect do
        described_class.import("University", names)
      end.to change(Institution.where(category: "University"), :count).by(names.count)
    end
  end
end
