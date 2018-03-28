require "renalware/admissions"
require "collection_presenter"

module Renalware
  module Admissions
    class ConsultsController < BaseController
      include Renalware::Concerns::Pageable

      # rubocop:disable Metrics/AbcSize
      def index
        session[:consults_results] = nil if params.key?(:reset)
        query = ConsultQuery.new(params[:q])
        consults = query.call.page(page).per(per_page)
        authorize consults
        render locals: {
          consults:  CollectionPresenter.new(consults, ConsultPresenter),
          query: query.search
        }
      end
      # rubocop:enable Metrics/AbcSize

      def new
        consult = Consult.new(started_on: Time.zone.today)
        authorize consult
        render_new(consult)
      end

      def create
        consult = Consult.new(consult_params)
        authorize consult
        if consult.save_by(current_user)
          redirect_to admissions_consults_path, notice: success_msg_for("consult")
        else
          render_new(consult)
        end
      end

      def edit
        session[:consults_results] = request&.referer # for back link
        render_edit(find_and_authorize_consult)
      end

      def update
        consult = find_and_authorize_consult
        if consult.update_by(current_user, consult_params)
          url = session[:consults_results] || admissions_consults_path
          redirect_to url, notice: success_msg_for("consult")
        else
          render_edit(consult)
        end
      end

      def destroy
        find_and_authorize_consult.update!(ended_on: Time.zone.now, by: current_user)
        redirect_to admissions_consults_path, notice: success_msg_for("consult")
      end

      private

      def find_and_authorize_consult
        Consult.find(params[:id]).tap do |consult|
          authorize consult
        end
      end

      def render_new(consult)
        render :new, locals: { consult: consult }
      end

      def render_edit(consult)
        render :edit, locals: { consult: consult }
      end

      def consult_params
        params
          .require(:admissions_consult)
          .permit(
            :consult_site_id, :hospital_ward_id, :patient_id, :q, :other_site_or_ward,
            :decided_on, :transferred_on, :started_on, :ended_on, :decided_on,
            :aki_risk, :transfer_priority, :seen_by_id, :consult_type,
            :requires_aki_nurse, :description, :contact_number, :rrt
          )
      end
    end
  end
end
