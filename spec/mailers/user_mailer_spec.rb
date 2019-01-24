require "rails_helper"

describe UserMailer, type: :mailer do
  describe "instructions" do
    let(:user) { FactoryGirl.create(:user) }
    let(:action_page) { FactoryGirl.create(:action_page) }

    it "escapes HTML in names" do
      bad_name = "<a href='junk.org'>Mallory</a>"
      mail = described_class.thanks_message(user.email, action_page, name: bad_name)
      expect(mail.body.encoded).not_to match(bad_name)
    end
  end
end
