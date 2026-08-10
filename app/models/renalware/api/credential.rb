module Renalware
  module API
    class Credential < ApplicationRecord
      self.table_name = "api_credentials"

      IssuedCredential = Data.define(:credential, :token)

      HD_SESSIONS_WRITE = "hd_sessions:write".freeze
      MIRTH_STATISTICS_WRITE = "mirth_statistics:write".freeze
      OUTGOING_DOCUMENTS_READ = "outgoing_documents:read".freeze
      OUTGOING_DOCUMENTS_WRITE = "outgoing_documents:write".freeze

      SCOPES = [
        HD_SESSIONS_WRITE,
        MIRTH_STATISTICS_WRITE,
        OUTGOING_DOCUMENTS_READ,
        OUTGOING_DOCUMENTS_WRITE
      ].freeze

      belongs_to :user

      validates :name, presence: true, uniqueness: { scope: :user_id }
      validates :token_digest, presence: true, uniqueness: true
      validates :token_prefix, presence: true
      validates :scopes, presence: true
      validate :scopes_are_supported

      scope :enabled, -> { where(enabled: true) }

      def self.authenticate(token)
        return if token.blank?

        enabled.find_by(token_digest: digest(token))&.then do |credential|
          credential unless credential.expired?
        end
      end

      def self.issue!(user:, name:, scopes:, expires_at: nil)
        token = SecureRandom.urlsafe_base64(32)
        credential = create!(
          user:,
          name:,
          scopes: Array(scopes),
          expires_at:,
          token_digest: digest(token),
          token_prefix: token.first(8)
        )

        IssuedCredential.new(credential:, token:)
      end

      def self.digest(token)
        OpenSSL::Digest::SHA256.hexdigest(token)
      end

      def expired?
        expires_at.present? && expires_at <= Time.current
      end

      def permits?(scope)
        scopes.include?(scope)
      end

      def record_usage!
        self.class
          .where(id:)
          .where("last_used_at IS NULL OR last_used_at < ?", 5.minutes.ago)
          .update_all(last_used_at: Time.current)
      end

      private

      def scopes_are_supported
        unsupported_scopes = scopes - SCOPES
        return if unsupported_scopes.empty?

        errors.add(:scopes, "contains unsupported values: #{unsupported_scopes.join(', ')}")
      end
    end
  end
end
