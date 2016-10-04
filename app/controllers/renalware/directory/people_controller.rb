module Renalware
  module Directory
    class PeopleController < BaseController
      def index
        query = PersonQuery.new(q: params[:q])
        @people = call_query(query).page(params[:page])
        authorize @people

        @q = query.search
      end

      def search
        authorize Person, :index?

        query = PersonQuery.new(q: { name_cont: params.fetch(:term) })
        render json: query.call.map { |person| { id: person.id, label: person.to_s } }.to_json
      end

      def show
        @person = Person.find(params[:id])
        authorize @person
      end

      def new
        @person = Person.build
        authorize @person
      end

      def create
        @person = Person.new(person_params)
        authorize @person

        if @person.save
          redirect_to directory_people_path, notice: t(".success", model_name: "Directory person")
        else
          flash[:error] = t(".failed", model_name: "Directory person")
          render :new
        end
      end

      def edit
        @person = Person.find(params[:id])
        authorize @person
      end

      def update
        @person = Person.find(params[:id])
        authorize @person
        if @person.update(person_params)
          redirect_to directory_people_path, notice: t(".success", model_name: "Directory person")
        else
          flash[:error] = t(".failed", model_name: "Directory person")
          render :edit
        end
      end

      private

      def call_query(query)
        query
          .call
          .with_address
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
