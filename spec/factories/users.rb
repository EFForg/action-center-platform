# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email, User.next_id) {|n| "darth_#{n}@sunni.ru" }
    password "password"
  end

  factory :admin_user, :parent => :user do
    after(:build) do |user|
      user.admin = true
      user.skip_confirmation!
      user.save
      # user.add_role :admin
    end
  end

  factory :activist_user, :parent => :user do
    after(:build) do |user|
      user.admin = true
      user.skip_confirmation!
      user.save
      # user.add_role :activist
    end
  end

end
