def get_stdin(msg, default, echo=true)
  STDOUT.puts "#{msg} (Default: '#{default}'):"

  input = (if echo
    STDIN.gets.strip
  else
    STDIN.noecho(&:gets)
  end)

  if input.blank?
    default
  else
    input
  end
end

namespace :users do
  desc 'Add a new User to Renalware.'
  task add_user: :environment do
    first_name = get_stdin('First name', 'Super')
    last_name = get_stdin('Last name', 'Admin')
    username = get_stdin('Username', 'superadmin')
    email = get_stdin('Email', 'superadmin@renalware.net')
    password = get_stdin('Password', 'supersecret', false)
    confirm_password = get_stdin('Password again', 'supersecret', false)
    available_role_names = Role.all.map { |r| "'#{r.name}'" }.join(',')
    role_name = get_stdin("Role, [#{available_role_names}]", 'super_admin')

    if Role.all.map(&:name).include?(role_name)
      role = Role.find_by!(name: role_name)
    else
      raise "Role #{role_name} does not exist"
    end

    if password == confirm_password
      User.find_or_create_by!(username: username) do |u|
        u.first_name = first_name
        u.last_name = last_name
        u.email = email
        u.password = password
        u.approved = true
        u.roles = [role]
      end
    else
      raise 'Passwords do not match'
    end
  end

  desc 'Approve a user'
  task :approve_user, [:username] => :environment do |t, args|
    user = User.find_by!(username: args[:username])
    puts "#{user.username} approved." if user.update_attributes(approved: true)
  end
end
