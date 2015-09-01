namespace :users do
  desc "List the emails of all admin accounts"
  task :list_admins => :environment do
    admins = User.where(admin: true).map do |u|
      u.email
    end.sort
    puts admins
  end
  desc "Remove admin status from an account, given an email"
  task :remove_admin, [:email] => :environment do |t, args|
    u = User.find_by_email(args[:email])
    u.admin = false
    u.save
  end
  desc "Add admin status from an account, given an email"
  task :add_admin, [:email] => :environment do |t, args|
    u = User.find_by_email(args[:email])
    u.admin = true
    u.save
  end
end
