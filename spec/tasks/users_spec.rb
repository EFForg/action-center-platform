require "rails_helper"
require "rake"

describe "User-related rake tasks" do
  let(:user) { FactoryGirl.create(:user) }
  let(:email) { user.email }
  let(:run_task) { Rake.application.invoke_task "#{task}[#{email}]" }

  before do
    Rake.application.rake_require("tasks/users")
    Rake::Task.define_task(:environment)
  end

  after { Rake.application[task].reenable }

  describe "users:add_admin" do
    let(:task) { "users:add_admin" }

    it "grants admin status to the given user" do
      expect(user.reload.admin?).to be_falsey
      run_task
      expect(user.reload.admin?).to be_truthy
    end

    it "returns a friendly message" do
      expect { run_task }.to output(
        /Successfully granted admin status to #{email}./
      ).to_stdout
    end

    context "when user can't be updated" do
      before { allow_any_instance_of(User).to receive(:save).and_return(false) }

      it "does not grant admin status" do
        expect(user.reload.admin?).to be_falsey
        run_task
        expect(user.reload.admin?).to be_falsey
      end

      it "returns a friendly message" do
        expect { run_task }.to output(
          /Granting admin status to #{email} failed./
        ).to_stdout
      end
    end

    context "when user is missing" do
      let(:email) { "nobody@nothing.net" }

      it "returns failure code" do
        expect { run_task }.to raise_error(
          /I couldn't find a user with the email '#{email}'/
        )
      end
    end
  end

  describe "users:remove_admin" do
    let(:user) { FactoryGirl.create(:user, admin: true) }
    let(:task) { "users:remove_admin" }

    it "grants admin status to the given user" do
      expect(user.reload.admin?).to be_truthy
      run_task
      expect(user.reload.admin?).to be_falsey
    end

    context "when user is missing" do
      let(:email) { "nobody@nothing.net" }

      it "returns failure code" do
        expect { run_task }.to raise_error(
          /I couldn't find a user with the email '#{email}'/
        )
      end
    end
  end
end
