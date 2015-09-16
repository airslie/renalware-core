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

def default_super_admin_attrs
  {
    first_name: 'Super',
    last_name: 'Admin',
    username: 'superadmin',
    email: 'superadmin@renalware.net',
    password: 'supersecret',
    roles: [Renalware::Role.find_by!(name: :super_admin)],
    approved: true,
    signature: 'Super Admin'
  }
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
    available_role_names = Renalware::Role.all.map { |r| "'#{r.name}'" }.join(',')
    role_name = get_stdin("Role, [#{available_role_names}]", 'super_admin')

    if Renalware::Role.all.map(&:name).include?(role_name)
      role = Renalware::Role.find_by!(name: role_name)
    else
      raise "Role #{role_name} does not exist"
    end

    if password == confirm_password
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.first_name = first_name
        u.last_name = last_name
        u.email = email
        u.password = password
        u.approved = true
        u.roles = [role]
        u.signature = "#{first_name} #{last_name}"
      end
    else
      raise 'Passwords do not match'
    end
  end

  desc 'Add default super admin'
  task add_super_admin: :environment do
    Renalware::User.find_or_create_by!(username: default_super_admin_attrs[:username]) do |u|
      default_super_admin_attrs.each do |k,v|
        u.send(:"#{k}=", v)
      end
    end
    puts "Super Admin credentials: #{default_super_admin_attrs[:username]}/#{default_super_admin_attrs[:password]}"
  end

  desc 'Approve a user'
  task :approve_user, [:username] => :environment do |t, args|
    user = Renalware::User.find_by!(username: args[:username])
    puts "#{user.username} approved." if user.update_attributes(approved: true)
  end
end
