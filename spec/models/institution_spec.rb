require "rails_helper"

describe Institution do
  describe ".top" do
    let(:petition) { FactoryBot.create(:local_organizing_petition) }

    let(:high_rank) { petition.action_page.institutions.create(name: "A", category: "University") }
    let(:mid_rank) { petition.action_page.institutions.create(name: "B", category: "University") }
    let(:low_rank) { petition.action_page.institutions.create(name: "C", category: "University") }

    let(:student) { petition.action_page.affiliation_types.find_or_create_by!(name: "Student") }

    before(:each) do
      100.times do
        sig = FactoryBot.create(:signature, petition_id: petition.id)
        sig.affiliations.create(institution_id: high_rank.id, affiliation_type: student)
      end

      50.times do
        sig = FactoryBot.create(:signature, petition_id: petition.id)
        sig.affiliations.create(institution_id: mid_rank.id, affiliation_type: student)
      end

      10.times do
        sig = FactoryBot.create(:signature, petition_id: petition.id)
        sig.affiliations.create(institution_id: low_rank.id, affiliation_type: student)
      end
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
