namespace :heidi do
  desc "Check Heidi linked-account status for selected Renalware users"
  task linked_accounts: :environment do
    users = Renalware::Heidi::LinkedAccountProbe.users_from_environment
    Renalware::Heidi::LinkedAccountProbe.new(users:).call
  rescue ArgumentError
    abort "Usage: bin/rails heidi:linked_accounts USER_ID=123|EMAIL=a@b.test|QUERY=smith"
  end

  desc "Unlink the Heidi account associated with one Renalware USER_ID"
  task unlink_account: :environment do
    user_id = ENV.fetch("USER_ID") do
      abort "Usage: bin/rails heidi:unlink_account USER_ID=123"
    end
    user = Renalware::User.find(user_id)
    result = Renalware::Heidi::Client.new.unlink_account(user)

    if result.success?
      puts "Unlinked Renalware user #{user.id} #{user.email}"
      puts JSON.pretty_generate(result.body) if result.body.present?
    else
      abort "Heidi unlink failed for Renalware user #{user.id}: #{result.error}"
    end
  end
end
