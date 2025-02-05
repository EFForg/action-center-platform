require "rails_helper"

RSpec.describe LoggedInvisibleCaptcha, type: :controller do
  controller(ApplicationController) do
    invisible_captcha honeypot: :foo, only: :create

    def create; end
  end

  it "blocks requests that fill the honeypot" do
    expect(controller).not_to receive(:create)
    post :create, params: { foo: "bar" }
  end

  it "logs spammy requests to Sentry" do
    expect(Sentry).to receive(:capture_message)
    post :create, params: { foo: "bar" }
  end
end
