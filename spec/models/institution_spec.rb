require "rails_helper"

describe Institution do
  describe ".top" do
    let(:petition) { FactoryGirl.create(:local_organizing_petition) }

    let(:high_rank) { petition.action_page.institutions.create(name: "A") }
    let(:mid_rank) { petition.action_page.institutions.create(name: "B") }
    let(:low_rank) { petition.action_page.institutions.create(name: "C") }

    before(:each) do
      100.times do
        sig = FactoryGirl.create(:signature, petition_id: petition.id)
        sig.affiliations.create(institution_id: high_rank.id)
      end

      50.times do
        sig = FactoryGirl.create(:signature, petition_id: petition.id)
        sig.affiliations.create(institution_id: mid_rank.id)
      end

      10.times do
        sig = FactoryGirl.create(:signature, petition_id: petition.id)
        sig.affiliations.create(institution_id: low_rank.id)
      end
    end

    it "should return the top n institutions ordered by number of signatures" do
      expect(petition.action_page.institutions.top(3).to_a).to eq([high_rank, mid_rank, low_rank])
    end

    it "should allow an argument which reorders a certain institution to the front" do
      expect(petition.action_page.institutions.top(3, first: low_rank.id).to_a).to eq([low_rank, high_rank, mid_rank])
    end
  end
end
