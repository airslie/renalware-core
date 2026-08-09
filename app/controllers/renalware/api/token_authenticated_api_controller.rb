require "devise"

module Renalware
  module API
    class TokenAuthenticatedAPIController < ApplicationController
      class MissingScopeError < StandardError; end

      class_attribute :api_scopes, instance_accessor: false, default: {}

      before_action :authenticate_api_request!

      def self.api_scope(scope, only: nil)
        actions = Array(only || "*").map(&:to_s)
        self.api_scopes = api_scopes.merge(actions.index_with { scope })
      end

      private

      def authenticate_api_request!
        return authenticate_bearer_request! if request.authorization.present?

        return if legacy_query_token_authenticated?

        deny_api_access
      end

      def authenticate_bearer_request!
        credential = bearer_credential
        return deny_api_access unless credential&.permits?(required_api_scope)

        authenticate_with_credential!(credential)
      end

      def bearer_credential
        authenticate_with_http_token do |token, _options|
          Credential.authenticate(token)
        end
      end

      def authenticate_with_credential!(credential)
        @current_api_credential = credential
        credential.record_usage!
        sign_in credential.user, store: false
      end

      # TODO: Remove this legacy query-string authentication mechanism once all clients have been
      # updated to use the Authorization header with a bearer token.
      def legacy_query_token_authenticated?
        return false unless Renalware.config.legacy_api_query_authentication_enabled

        user = legacy_query_user
        return false if user.blank?

        warn_about_legacy_query_authentication(user)
        sign_in user, store: false
        true
      end

      def legacy_query_user
        username = params[:username].presence
        token = params[:token].presence
        return if username.blank? || token.blank?

        user = User.find_by(username:)
        return if user&.authentication_token.blank?
        return unless ::Devise.secure_compare(user.authentication_token, token)

        user
      end

      def warn_about_legacy_query_authentication(user)
        Rails.logger.warn(
          "[DEPRECATION] Legacy query-string API authentication used " \
          "username=#{user.username.inspect} path=#{request.path.inspect}"
        )
      end

      def required_api_scope
        self.class.api_scopes.fetch(action_name) do
          self.class.api_scopes.fetch("*") do
            raise MissingScopeError, "No API scope configured for #{self.class.name}##{action_name}"
          end
        end
      end

      def deny_api_access
        response.set_header("WWW-Authenticate", 'Bearer realm="Renalware API"')
        render(
          json: { error: I18n.t("devise.failure.unauthenticated") },
          status: :unauthorized
        )
      end
    end
  end
end
