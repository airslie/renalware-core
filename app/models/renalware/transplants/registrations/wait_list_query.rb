module Renalware
  module Transplants
    module Registrations
      class WaitListQuery
        def initialize(quick_filter:, q: nil)
          @quick_filter = quick_filter.to_sym
          @q = q || {}
        end

        def call
          search.result
        end

        def search
          @search ||= begin
            query = query_for_filter(@quick_filter).merge(@q)
            QueryableRegistration
              .includes(patient: [current_modality: :description])
              .search(query).tap do |s|
                s.sorts = ["patient_family_name, patient_given_name"]
            end
          end
        end

        private

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
          end
        end

        class QueryableRegistration < ActiveType::Record[Registration]
          scope :current_status_in, lambda { |codes|
            codes ||= %w(active)
            joins(statuses: :description)
              .where(transplant_registration_statuses: { terminated_on: nil })
              .where(transplant_registration_status_descriptions: { code: codes })
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

          private_class_method :ransackable_scopes

          def self.ransackable_scopes(_auth_object = nil)
            %i(current_status_in)
          end
        end
      end
    end
  end
end
