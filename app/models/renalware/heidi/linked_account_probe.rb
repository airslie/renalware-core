module Renalware
  module Heidi
    class LinkedAccountProbe
      MAX_QUERY_RESULTS = 20

      def self.users_from_environment
        user_id = ENV["USER_ID"].presence
        email = ENV["EMAIL"].presence
        query = ENV["QUERY"].presence

        return Renalware::User.where(id: user_id) if user_id
        return Renalware::User.where("lower(email) = ?", email.downcase) if email
        return query_users(query) if query

        raise ArgumentError, "USER_ID, EMAIL, or QUERY is required"
      end

      def self.query_users(query)
        pattern = "%#{ActiveRecord::Base.sanitize_sql_like(query.downcase)}%"
        Renalware::User
          .where(
            "lower(email) LIKE :pattern OR lower(given_name) LIKE :pattern OR " \
            "lower(family_name) LIKE :pattern",
            pattern:
          )
          .order(:family_name, :given_name)
          .limit(MAX_QUERY_RESULTS)
      end

      def initialize(users:, client: Renalware::Heidi::Client.new, output: $stdout)
        @users = users
        @client = client
        @output = output
      end

      def call
        users.each { |user| print_link_status(user) }
      end

      private

      attr_reader :users, :client, :output

      def print_link_status(user)
        result = client.linked_account_access(user)
        output.puts(
          JSON.pretty_generate(
            renalware_user: user_attributes(user),
            heidi: heidi_attributes(result)
          )
        )
      end

      def user_attributes(user)
        {
          id: user.id,
          email: user.email,
          uuid: user.uuid,
          name: user.to_s
        }
      end

      def heidi_attributes(result)
        return result.body if result.success?

        {
          success: false,
          status: result.status,
          error: result.error,
          body: result.body
        }
      end
    end
  end
end
