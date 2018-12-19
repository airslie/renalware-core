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
              .eager_load(patient: [current_modality: :description])
              .eager_load(current_status: :description)
              .merge(HD::Patient.with_profile)
              .merge(Renal::Patient.with_profile)
              .ransack(query).tap do |s|

              s.sorts = ["patient_family_name, patient_given_name"]
            end
          end
        end

        # The status_mismatch filter finds patients with a UKT status that does not match their
        # tx wait list status. We filter out UKT statuses of null or ''.
        # At some point we will have turn this into a mapping object or hash because there will
        # probably not be a 1 to 1 mapping from wait list to UKT status.
        module Scopes
          # rubocop:disable Metrics/MethodLength
          def apply_filter(filter)
            case filter
            when :status_mismatch
              joins(statuses: :description)
              .where(transplant_registration_statuses: { terminated_on: nil })
              .where(
                <<-SQL.squish
                (
                  transplant_registration_status_descriptions.code in ('active','suspended')
                  and
                  (
                    transplant_registrations.document -> 'uk_transplant_centre' ->> 'status' not ilike '%' || transplant_registration_status_descriptions.code || '%'
                    or
                    transplant_registrations.document -> 'uk_transplant_centre' ->> 'status' = ''
                    or
                    transplant_registrations.document -> 'uk_transplant_centre' ->> 'status' IS NULL
                  )
                )
                or
                (
                  transplant_registration_status_descriptions.code not in ('active','suspended')
                  and
                  (
                    transplant_registrations.document -> 'uk_transplant_centre' ->> 'status' ilike '%active%'
                    or
                    transplant_registrations.document -> 'uk_transplant_centre' ->> 'status' ilike '%suspended%'
                  )
                )
                SQL
              )
            else
              all
            end
          end
          # rubocop:enable Metrics/MethodLength
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

          ransacker :crf_highest_value do
            Arel.sql("transplant_registrations.document -> 'crf' -> 'highest' ->> 'result'")
          end

          ransacker :crf_latest_value do
            Arel.sql("transplant_registrations.document -> 'crf' -> 'latest' ->> 'result'")
          end

          # TODO: move ransacker to HD namespace
          ransacker :hd_site do
            Arel.sql("hospital_units.unit_code")
          end

          # TODO: move ransacker to Renal namespace
          ransacker :esrf_on do
            Arel.sql("renal_profiles.esrf_on")
          end

          # TODO: move ransacker to Renal namespace
          ransacker :patient_current_status_description_name do
            Arel.sql("transplant_registration_status_descriptions.name")
          end

          ransacker :ukt_status do
            Arel.sql(<<-SQL)
              COALESCE(
                transplant_registrations.document -> 'uk_transplant_centre' ->> 'status',
                ''
              )
            SQL
          end

          private_class_method :ransackable_scopes

          def self.ransackable_scopes(_auth_object = nil)
            %i(current_status_in)
          end
        end
      end
    end
  end
end
