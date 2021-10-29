# frozen_string_literal: true

require_dependency("renalware/clinics")

module Renalware
  module Clinics
    class ConsultantsController < BaseController
      def index
        consultants = Consultant
          .with_deleted
          .ordered
          .with_appointment_fields
        authorize consultants
        render locals: { consultants: consultants }
      end

      def new
        consultant = Consultant.new
        authorize consultant
        render locals: { consultant: consultant }
      end

      def create
        consultant = Consultant.new(consultant_params.merge(by: current_user))
        authorize consultant
        if consultant.save
          redirect_to consultants_path
        else
          render "new", locals: { consultant: consultant }
        end
      end

      def edit
        render locals: { consultant: find_and_authorise_consultant }
      end

      def update
        consultant = find_and_authorise_consultant
        if consultant.update(consultant_params.merge(by: current_user))
          redirect_to consultants_path
        else
          render "edit", locals: { consultant: consultant }
        end
      end

      def destroy
        consultant = find_and_authorise_consultant
        consultant.update!(by: current_user)
        consultant.destroy
        redirect_to consultants_path, notice: success_msg_for("consultant")
      end

      private

      def consultant_params
        params.require(:consultant).permit(:name, :code, :telephone)
      end

      def find_and_authorise_consultant
        Consultant.find(params[:id]).tap { |consultant| authorize(consultant) }
      end
    end
  end
end
