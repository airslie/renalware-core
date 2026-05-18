module Renalware
  class Configuration
    module Users
      def self.included(base)
        register_authentication_settings(base)
        register_devise_settings(base)
        register_ldap_group_settings(base)
        register_ldap_connection_settings(base)
        register_ldap_attribute_settings(base)
      end

      def self.register_authentication_settings(base)
        base.config_accessor(:authentication_providers) do
          ENV.fetch("AUTHENTICATION_PROVIDERS", "database")
            .split(",")
            .filter_map do |provider|
              provider.strip.presence&.to_sym
            end
            .uniq
        end
      end

      def self.register_devise_settings(base)
        # Hospital-specific devise modules to load (comma-separated list, e.g., "module1,module2").
        base.config_accessor(:devise_extra_modules) do
          ENV.fetch("DEVISE_EXTRA_MODULES", "").split(",").map { it.strip.to_sym }
        end
      end

      def self.register_ldap_group_settings(base)
        # If true, LDAP queries will be logged (may expose sensitive info, use only for debugging).
        base.config_accessor(:ldap_logger) { ENV.fetch("LDAP_LOGGER", "false") == "true" }
        base.config_accessor(:ldap_auto_approve_users) do
          ENV.fetch("LDAP_AUTO_APPROVE_USERS", "true") == "true"
        end

        base.config_accessor(:ldap_clinical_group) do
          ENV.fetch("LDAP_CLINICAL_GROUP", "cn=renalware (clinical),ou=groups,dc=renalware,dc=app")
        end

        base.config_accessor(:ldap_readonly_group) do
          ENV.fetch("LDAP_READONLY_GROUP", "cn=renalware (readonly),ou=groups,dc=renalware,dc=app")
        end
      end

      def self.register_ldap_connection_settings(base)
        base.config_accessor(:ldap_host) { ENV.fetch("LDAP_HOST", "localhost") }
        base.config_accessor(:ldap_port) { ENV.fetch("LDAP_PORT", 389).to_i }
        base.config_accessor(:ldap_admin_password) { ENV.fetch("LDAP_ADMIN_PASSWORD", nil) }
        base.config_accessor(:ldap_admin_user) { ENV.fetch("LDAP_ADMIN_USER", "treacle@ad.test") }
        base.config_accessor(:ldap_base) { ENV.fetch("LDAP_BASE", "dc=renalware,dc=app") }
        base.config_accessor(:ldap_user_upn_suffix) { ENV.fetch("LDAP_USER_UPN_SUFFIX", "ad.test") }
        base.config_accessor(:ldap_verify_mode) { OpenSSL::SSL::VERIFY_NONE }
      end

      def self.register_ldap_attribute_settings(base)
        base.config_accessor(:ldap_attribute_mappings) do
          default_mappings = {
            "username" => "uid",
            "email" => "mail",
            "given_name" => "givenName",
            "family_name" => "sn"
          }
          mappings_string = ENV.fetch("LDAP_ATTRIBUTE_MAPPINGS", nil)
          custom_mappings = mappings_string ? JSON.parse(mappings_string) : {}
          default_mappings.merge(custom_mappings)
        end
      end

      def authentication_provider_enabled?(provider)
        authentication_providers.include?(provider.to_sym)
      end

      def database_authentication_enabled?
        authentication_provider_enabled?(:database)
      end

      def ldap_authentication_enabled?
        authentication_provider_enabled?(:ldap)
      end

      def entra_authentication_enabled?
        authentication_provider_enabled?(:entra_id)
      end
    end
  end
end
