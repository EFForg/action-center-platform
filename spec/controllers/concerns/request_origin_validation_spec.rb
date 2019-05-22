require "rails_helper"

RSpec.describe RequestOriginValidation do
  controller_class = Class.new(ActionController::Base) do
    include RequestOriginValidation
  end

  let(:controller) { controller_class.new }

  describe "#verify_request_origin" do
    context "same origin request" do
      let!(:request) do
        OpenStruct.new(
          headers: { "origin" => "https://example.com" },
          base_url: "https://example.com",
          "get?": false,
          "head?": false
        ).tap do |request|
          allow(controller).to receive(:request) { request }
        end
      end

      it "should not raise an error for any method" do
        request["get?"] = true
        expect { controller.verify_request_origin }.not_to raise_error
        request["get?"] = false

        request["head?"] = true
        expect { controller.verify_request_origin }.not_to raise_error
        request["head?"] = false

        request["post?"] = true
        expect { controller.verify_request_origin }.not_to raise_error
      end
    end

    context "cross origin request" do
      let!(:request) do
        OpenStruct.new(
          headers: { "origin" => "https://example.org" },
          base_url: "https://example.net",
          "get?": false,
          "head?": false
        ).tap do |request|
          allow(controller).to receive(:request) { request }
        end
      end

      it "should not raise an error for GET or HEAD methods" do
        request["get?"] = true
        expect { controller.verify_request_origin }.not_to raise_error
        request["get?"] = false

        request["head?"] = true
        expect { controller.verify_request_origin }.not_to raise_error
        request["head?"] = false
      end

      it "should raise an error for POST requests" do
        request["post?"] = true
        expect { controller.verify_request_origin }.
          to raise_error(ActionController::InvalidCrossOriginRequest)
      end
    end
  end
end
