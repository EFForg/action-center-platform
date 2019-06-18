require "rails_helper"

describe CongressForms do
  describe CongressForms::Form do
    let(:form) {
      CongressForms::Form.new("C000880", [
        {"value" => "$NAME_FIRST"},
        {"value" => "$NAME_LAST"},
        {"value" => "$ADDRESS_STATE", "options_hash" => {
            "CALIFORNIA" => "CA",
            "NEW YORK" => "NY"
          }
        }
      ])
    }

    let(:input) { {
      "$NAME_FIRST" => "Willow",
      "$NAME_LAST" => "Rosenberg",
      "$MESSAGE" => "Impeach Mayor Richard Wilkins III",
      "$ADDRESS_STATE" => "CA"
    } }

    describe "::find" do
      before do
        stub_request(:post, /retrieve-form-elements/).
          with(:body => {"bio_ids"=>["C000880", "A000360"]}).
          and_return(status: 200, body: file_fixture('retrieve-form-elements.json'))
      end

      it "retrieves a Form for each bioguide_id" do
        forms = CongressForms::Form.find(["C000880", "A000360"])
        expect(forms.length).to eq 2
        lamar = forms.first
        expect(lamar.fields.length).to eq 11
        expect(lamar.fields.first.value).to eq "$NAME_FIRST"
      end
    end

    describe "#validate" do
      it "returns true with valid input" do
        expect(form.validate(input)).to be true
      end

      it "returns false with a missing field" do
        input.delete("$NAME_FIRST")
        expect(form.validate(input)).to be false
      end

      it "returns false with an invalid option" do
        input["$ADDRESS_STATE"] = "THE HELL MOUTH"
        expect(form.validate(input)).to be false
      end
    end

    describe "#fill" do
      it "posts only required fields to the congress forms API" do
        stub_request(:post, /fill-out-form/).
          with(:body => {"bioguide_id"=>"C000880", "fields"=>input}).
          and_return(status: 200, body: "{}")
        form.fill(input.merge({ "EXTRA" => "Should be omitted"}))
        expect(WebMock).to have_requested(:post, /fill-out-form/).
          with(:body => {"bioguide_id"=>"C000880", "fields"=>input})
      end
    end
  end
end

