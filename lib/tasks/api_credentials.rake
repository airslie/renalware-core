namespace :renalware do
  namespace :api_credentials do
    desc "Issue a scoped API bearer token from API_* environment variables"
    task issue: :environment do
      username = ENV.fetch("API_USERNAME")
      name = ENV.fetch("API_CREDENTIAL_NAME")
      scopes = ENV.fetch("API_SCOPES").split(",").map(&:strip)
      expires_at = Time.zone.parse(ENV["API_EXPIRES_AT"]) if ENV["API_EXPIRES_AT"].present?
      user = Renalware::User.find_by!(username:)

      issued = Renalware::API::Credential.issue!(user:, name:, scopes:, expires_at:)

      puts "Credential id: #{issued.credential.id}"
      puts "Token prefix: #{issued.credential.token_prefix}"
      puts "Bearer token (shown once): #{issued.token}"
    end
  end
end
