# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    class TransmissionLog < ApplicationRecord
      validates :sent_at, presence: true
      validates :status, presence: true
      belongs_to :patient, class_name: "Renalware::Patient"
      enum status: [:undefined, :error, :unsent_no_change_since_last_send, :sent]
      scope :ordered, ->{ order(sent_at: :asc) }

      def self.with_logging(patient, request_uuid)
        log = new(patient: patient, sent_at: Time.zone.now, request_uuid: request_uuid)
        yield log if block_given?
        log.save!
      rescue StandardError => error
        log.error << formatted_exception(error)
        log.status = :error
        log.save!
        raise error
      end

      def self.formatted_exception(error)
        [
          "#{error.backtrace.first}: #{error.message} (#{error.class})",
          error.backtrace.drop(1).map{ |line| "\t#{line}" }
        ].join("\n")
      end
    end
  end
end
