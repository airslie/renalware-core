module Renalware
  module Directory
    class PeopleController < BaseController
      include Renalware::Concerns::Pageable

      before_action :load_person, only: [:show, :edit, :update]
      before_action :prepare_paging, only: [:index]

      def index
        @people = Person
          .with_address
          .ordered.page(@page).per(@per_page)
        authorize @people
      end

      def show
      end

      def new
        @person = Person.new
        authorize @person
      end

      def create
        @person = Person.new(person_params)
        authorize @person

        if @person.save
          redirect_to directory_people_path,
            notice: t(".success", model_name: "Directory person")
        else
          flash[:error] = t(".failed", model_name: "Directory person")
          render :new
        end
      end

      def update
        if @person.update(person_params)
          redirect_to directory_people_path,
            notice: t(".success", model_name: "Directory person")
        else
          flash[:error] = t(".failed", model_name: "Directory person")
          render :edit
        end
      end

      def destroy
        authorize Person.destroy(params[:id])
        redirect_to directory_people_path,
          notice: t(".success", model_name: "Directory person")
      end

      protected

      def load_person
        @person = Person.find(params[:id])
        authorize @person
      end

      def person_params
        params
          .require(:directory_person)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        [
          :given_name, :family_name, :title,
          address_attributes: address_attributes
        ]
      end

      def address_attributes
        [
          :id, :name, :organisation_name, :street_1, :street_2, :city, :county,
          :postcode, :country, :_destroy
        ]
      end
    end
  end
end
