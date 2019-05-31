require "rails_helper"

RSpec.describe LoggedInvisibleCaptcha, type: :controller do
  controller(ApplicationController) do
    # include LoggedInvisibleCaptcha
    invisible_captcha honeypot: :foo, only: :create

    def create
      byebug
    end
  end

  it "blocks requests with a timestamp" do
    expect(controller).not_to receive(:create)
    post :create, foo: "bar"
  end
end
