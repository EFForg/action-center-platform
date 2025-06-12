# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :unconfirmed_user, class: User do
    sequence(:email) { |n| "person_#{n}@example.com" }
    password { "strong passwords defeat lobsters covering wealth" }
  end

  factory :user, parent: :unconfirmed_user do
    after(:build, &:skip_confirmation!)
  end

  factory :admin_user, parent: :user do
    after(:build) do |user|
      user.admin = true
      user.save
      # user.add_role :admin
    end
  end

  factory :collaborator_user, parent: :user do
    after(:build) do |user|
      user.collaborator = true
      user.save
      # user.add_role :collaborator
    end
  end

  factory :activist_user, parent: :user do
    after(:build) do |user|
      user.admin = true
      user.save
      # user.add_role :activist
    end
  end
end
