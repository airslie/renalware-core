module Renalware
  module Transplants
    module Registrations
      class WaitListQuery
        attr_reader :term, :page, :per_page

        def initialize(quick_filter:, page: 1, per_page: 50)
          @quick_filter = quick_filter.to_sym
          @page = page
          @per_page = per_page
        end

        def call
          search.result.page(page).per(per_page)
        end

        private

        def search
          @search ||= begin
            QueryableRegistration.search(query_for_filter(@quick_filter)).tap do |s|
              s.sorts = ["patient_last_name, patient_first_name"]
            end
          end
        end

        def query_for_filter(filter)
          case filter
          when :active
            { current_status_in: :active }
          when :suspended
            { current_status_in: :suspended }
          when :active_and_suspended
            { current_status_in: [%w(active suspended)] }
          when :working_up
            { current_status_in: [%w(working_up working_up_lrf)] }
          when :nhb_consent
            { nhb_consent_eq: "yes" }
          end # note: array must be embedded in another array as mentionned in the Ransack readme
        end

        class QueryableRegistration < ActiveType::Record[Registration]
          scope :current_status_in, -> (codes = %w(active)) {
            joins(statuses: :description)
              .where(transplants_registration_statuses: { terminated_on: nil })
              .where(transplants_registration_status_descriptions: { code: codes })
          }
          scope :nhb_consent_eq, -> (enum = "yes") {
            where("document @> ?", { nhb_consent: { value: enum } }.to_json )
          }

          private

          def self.ransackable_scopes(auth_object = nil)
            %i(nhb_consent_eq current_status_in)
          end
        end
      end
    end
  end
end