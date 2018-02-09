namespace :users do
  desc "List the emails of all admin accounts"
  task list_admins: :environment do
    admins = User.where(admin: true).map do |u|
      u.email
    end.sort
    puts admins.empty? ? "No Admin Users" : admins
  end

  desc "Remove admin status from an account, given an email"
  task :remove_admin, [:email] => :environment do |t, args|
    u = User.find_by_email(args[:email])
    abort("I couldn't find a user with the email '#{args[:email]}'.") unless u

    u.admin = false
    u.save
  end

  desc "Add admin status from an account, given an email"
  task :add_admin, [:email] => :environment do |t, args|
    email = args[:email]
    u = User.find_by_email(email)
    abort("I couldn't find a user with the email '#{email}'.") unless u

    u.admin = true
    if u.save
      puts "Successfully granted admin status to #{email}."
    else
      puts "Granting admin status to #{email} failed."
    end
  end
end
