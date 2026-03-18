namespace :users do
  desc "Create a new user, given an email"
  task :create, [:email] => :environment do |_t, args|
    email = args[:email]
    STDOUT.puts "Password for user: "
    password = STDIN.gets.strip

    STDOUT.puts "Confirm password: "
    password_confirmation = STDIN.gets.strip

    user = User.new(email: email, password: password, password_confirmation: password_confirmation)

    if password != password_confirmation
      abort("Password and password confirmation must match")
    elsif !user.valid?
      abort("Error creating user: #{user.errors.full_messages.join(", ")}")
    else
      user.save
      puts "User #{email} successfully created"
    end
  end

  desc "List the emails of all admin accounts"
  task list_admins: :environment do
    admins = User.where(admin: true).map(&:email).sort
    puts admins.empty? ? "No Admin Users" : admins
  end

  desc "Remove admin status from an account, given an email"
  task :remove_admin, [:email] => :environment do |_t, args|
    u = User.find_by(email: args[:email])
    abort("I couldn't find a user with the email '#{args[:email]}'.") unless u

    u.admin = false
    u.save
  end

  desc "Add admin status from an account, given an email"
  task :add_admin, [:email] => :environment do |_t, args|
    email = args[:email]
    u = User.find_by(email: email)
    abort("I couldn't find a user with the email '#{email}'.") unless u

    u.admin = true
    if u.save
      puts "Successfully granted admin status to #{email}."
    else
      puts "Granting admin status to #{email} failed."
    end
  end

  desc "Delete non-admins"
  task delete_nonadmins: :environment do |_t, args|
    delete_count = User.where(admin: false).count
    retain_count = User.where(admin: true).count
    puts "#{Time.now}: Deleting #{delete_count} non-admin user accounts. Retaining #{retain_count} admin accounts."
    User.where(admin: false).in_batches.each_with_index do |batch, batch_index|
      puts "#{Time.now}: Processing batch #{batch_index}"
      batch.delete_all
    end
    puts "#{Time.now}: Deletion complete"
  end
end
