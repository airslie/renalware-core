module Renalware
  module Medications
    module DrugTypes
      class PrescriptionsController < BaseController
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
          page = params.fetch(:page, 1)
          per_page = params.fetch(:per_page, 10)
          query.call.page(page).per(per_page)
        end

        def query
          PrescriptionsByDrugTypeQuery.new(
            drug_type_name: drug_type_name,
            search_params: params[:q]
          )
        end

        def drug_type_name
          params.fetch(:drug_type_name)
        end
      end
    end
  end
end
