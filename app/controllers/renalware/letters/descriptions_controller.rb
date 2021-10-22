# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class DescriptionsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        descriptions = Description.with_deleted.ordered
        authorize descriptions
        render locals: { descriptions: descriptions }
      end

      def new
        description = Description.new
        authorize description
        render_new description
      end

      def create
        description = Description.new(description_params)
        authorize description
        if description.save
          redirect_to letters_descriptions_path
        else
          render_new description
        end
      end

      def edit
        render_edit find_and_authorise_description
      end

      def update
        description = find_and_authorise_description
        if description.update(description_params)
          redirect_to letters_descriptions_path
        else
          render_edit description
        end
      end

      def destroy
        find_and_authorise_description.destroy
        redirect_to letters_descriptions_path
      end

      def sort
        authorize Description, :sort?
        ids = params[:letters_description]
        Description.sort(ids)
        render json: ids
      end

      private

      def render_new(description)
        render "new", locals: { description: description }
      end

      def render_edit(description)
        render "edit", locals: { description: description }
      end

      def description_params
        params.require(:description).permit(:text, :position)
      end

      def find_and_authorise_description
        Description.find(params[:id]).tap { |description| authorize description }
      end
    end
  end
end
