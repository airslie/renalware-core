# frozen_string_literal: true

require_dependency "renalware/transplants"

module Renalware
  module Transplants
    module Registrations
      class WaitListQuery
        def initialize(named_filter:, q: nil)
          @named_filter = named_filter&.to_sym || :active
          @q = (q || ActionController::Parameters.new).permit(:s, :q)
        end

        def call
          search
            .result
            .extending(Scopes)
            .apply_filter(named_filter)
        end

        def search
          @search ||= begin
            query = query_for_filter(named_filter).merge(q)
            QueryableRegistration
              .includes(patient: [current_modality: :description])
              .search(query).tap do |s|
              s.sorts = ["patient_family_name, patient_given_name"]
            end
          end
        end

        # Mixing in some scopes here rather than using ransack as I cannot get ransack scopes
        # to 'or' together other scopes like this. I seem to spend a lot of time debugging the
        # vagaries of ransack and wonder if its more pain that its worth!
        module Scopes
          def apply_filter(filter)
            case filter
            when :status_mismatch
              current_status_is_active.ukt_status_is_not_active
              .or(current_status_is_not_active.ukt_status_is_active)
            else
              all
            end
          end
        end

        private

        attr_reader :q, :named_filter

        def query_for_filter(filter)
          case filter
          when :active
            { current_status_in: :active }
          when :suspended
            { current_status_in: :suspended }
          when :active_and_suspended
            # note: array must be embedded in another array as mentioned here:
            # https://github.com/activerecord-hackery/ransack#using-scopesclass-methods
            { current_status_in: [%w(active suspended)] }
          when :working_up
            { current_status_in: [%w(working_up working_up_lrf)] }
          when :status_mismatch
            {} # See Scopes
          end
        end

        class QueryableRegistration < ActiveType::Record[Registration]
          scope :current_status_in, lambda { |codes|
            codes ||= %w(active)
            joins(statuses: :description)
              .where(transplant_registration_statuses: { terminated_on: nil })
              .where(transplant_registration_status_descriptions: { code: codes })
          }

          scope :current_status_not_in, lambda { |codes|
            codes ||= %w(active)
            joins(statuses: :description)
              .where(transplant_registration_statuses: { terminated_on: nil })
              .where.not(transplant_registration_status_descriptions: { code: codes })
          }

          ransacker :uk_transplant_centre_code do
            Arel.sql("transplant_registrations.document -> 'codes' ->> 'uk_transplant_centre_code'")
          end

          ransacker :crf_highest_value do
            Arel.sql("transplant_registrations.document -> 'crf' -> 'highest' ->> 'result'")
          end

          ransacker :crf_latest_value do
            Arel.sql("transplant_registrations.document -> 'crf' -> 'latest' ->> 'result'")
          end

          scope :ukt_status_is, lambda { |status|
            where(
              "transplant_registrations.document -> 'uk_transplant_centre' ->> 'status' ilike ?",
              status
            )
          }
          scope :ukt_status_is_not, lambda { |status|
            where.not(
              "transplant_registrations.document -> 'uk_transplant_centre' ->> 'status' ilike ?",
              status
            )
          }
          scope :current_status_is_active, ->{ current_status_in(:active) }
          scope :current_status_is_not_active, ->{ current_status_not_in(:active) }
          scope :ukt_status_is_active, ->{ ukt_status_is(:active) }
          scope :ukt_status_is_not_active, ->{ ukt_status_is_not(:active) }

          private_class_method :ransackable_scopes

          def self.ransackable_scopes(_auth_object = nil)
            %i(current_status_in
               current_status_not_in
               current_status_is_active
               current_status_is_not_active
               ukt_status_is
               ukt_status_is_not
               ukt_status_is_active
               ukt_status_is_not_active
               status_mismatches)
          end
        end
      end
    end
  end
end
