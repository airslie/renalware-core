module Renalware
  module Users
    class EntraOmniauthUser
      class NotAuthorisedError < StandardError; end

      def initialize(auth:)
        @auth = auth
      end

      def call
        verify_tenant!
        user = linked_user || user_matching_email || build_user
        user.azure_uid = auth.uid
        User.sync_roles(user, app_roles)
        raise NotAuthorisedError, "User has no managed Entra app role" unless authorised?(user)

        user.save! if user.changed?
        user
      end

      private

      attr_reader :auth

      def verify_tenant!
        configured_tenant_id = Renalware.config.entra_tenant_id
        return if configured_tenant_id.present? && raw_info["tid"] == configured_tenant_id

        raise NotAuthorisedError, "Token was not issued by the configured Entra tenant"
      end

      def linked_user
        User.find_by(azure_uid: auth.uid)
      end

      def user_matching_email
        existing = User.find_by(email:) if email.present?
        return if existing.nil?

        unless Renalware.config.entra_link_users_by_email && existing.azure_uid.blank?
          raise NotAuthorisedError, "A user with this email already exists and is not linked"
        end

        existing
      end

      def build_user
        User.new(
          username: auth.uid,
          email:,
          given_name: info.first_name,
          family_name: info.last_name,
          password: SecureRandom.hex(32),
          approved: Renalware.config.ldap_auto_approve_users,
          hospital_centre: Renalware::Hospitals::Centre.site_default
        )
      end

      def authorised?(user)
        user.roles.any? { |role| role.ad_role_name.present? }
      end

      def app_roles
        raw_info["roles"]
      end

      def raw_info
        auth.extra.raw_info
      end

      def info
        auth.info
      end

      def email
        info.email&.downcase
      end
    end
  end
end
