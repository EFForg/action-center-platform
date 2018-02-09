require "rails_helper"

RSpec.describe WelcomeController, type: :controller do
  it "should get the root page at least..." do
    get :index
    expect(response.code).to eq "200"
  end

  context "Rails.application.config.esi_enabled" do
    render_views
    it "should use edge side includes for csrf tags" do
      allow(Rails.application.config).to receive(:esi_enabled){ true }

      get :index
      expect(response.body).to include(%(<esi:include src="/csrf_protection/meta_tags.html" />))
    end
  end

  context "!Rails.application.config.esi_enabled" do
    render_views
    it "should not use edge side includes for csrf tags" do
      allow(Rails.application.config).to receive(:esi_enabled){ false }

      get :index
      expect(response.body).not_to include(%(<esi:include src="/csrf_protection/meta_tags.html" />))
    end
  end
end
