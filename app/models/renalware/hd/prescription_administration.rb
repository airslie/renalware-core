# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    class PrescriptionAdministration < ApplicationRecord
      include Accountable
      attr_accessor :administrator_authorisation_token
      attr_accessor :witness_authorisation_token

      # Set to true by the parent hd_session if we are not signing off at this stage
      attr_accessor :skip_validation

      belongs_to :hd_session, class_name: "HD::Session", touch: true
      belongs_to :prescription, class_name: "Medications::Prescription"
      belongs_to :administered_by, class_name: "User"
      belongs_to :witnessed_by, class_name: "User"
      validates :administered, inclusion: { in: [true, false] }, unless: :skip_validation
      validates :prescription, presence: true
      validates :administered_by, presence: true, unless: :skip_validation
      validates :witnessed_by, presence: true, unless: :skip_validation
      validate :check_administrator_authorisation_token
      validate :check_witness_authorisation_token

      private

      def check_administrator_authorisation_token
        verify_submitted_user_token(
          administered_by,
          administrator_authorisation_token,
          :administrator_authorisation_token
        )
      end

      def check_witness_authorisation_token
        verify_submitted_user_token(
          witnessed_by,
          witness_authorisation_token,
          :witness_authorisation_token
        )
      end

      def verify_submitted_user_token(user, token, error_key)
        return if skip_validation
        return if user.blank? || administered.nil? || administered == false

        if token.blank?
          errors[error_key] << "can't be blank"
        elsif user.auth_token != token
          errors[error_key] << "invalid token"
        end
      end
    end
  end
end
