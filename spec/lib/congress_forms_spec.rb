require "rails_helper"

describe CongressForms do
  describe CongressForms::Form do
    before do
      stub_request(:post, /retrieve-form-elements/).
        with(:body => {"bio_ids"=>["C000880", "A000360"]}).
        and_return(status: 200, body: file_fixture('retrieve-form-elements.json'))
    end

    describe "::find" do
      it "retrieves a Form for each bioguide_id" do
        forms = CongressForms::Form.find(["C000880", "A000360"])
        expect(forms.length).to eq 2
        lamar = forms.first
        expect(lamar.fields.length).to eq 11
        expect(lamar.fields.first.value).to eq "$NAME_FIRST"
      end
    end

    describe "#validate" do
    end
  end

  describe CongressForms::Field do
    describe "#validate" do
    end
  end
end

