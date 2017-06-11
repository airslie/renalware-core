module Renalware
  module Medications
    module DrugTypes
      class PrescriptionsController < BaseController
        include Renalware::Concerns::Pageable

        def index
          authorize Prescription, :index?
          render :index, locals: {
            prescriptions: present_prescriptions,
            search: query.search
          }
        end

        private

        def present_prescriptions
          CollectionPresenter.new(paginated_prescriptions, PrescriptionPresenter)
        end

        def paginated_prescriptions
          query.call.page(page).per(per_page)
        end

        def query
          @query ||= begin
            PrescriptionsByDrugTypeQuery.new(
              drug_type_name: drug_type_name,
              search_params: params[:q]
            )
          end
        end

        def drug_type_name
          params.fetch(:drug_type_name)
        end
      end
    end
  end
end
