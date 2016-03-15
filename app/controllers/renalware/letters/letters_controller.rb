require_dependency "renalware/letters"
require "smart_delegator"

module Renalware
  module Letters
    class LettersController < Letters::BaseController
      before_filter :load_patient

      def index
        @letters = @patient.letters
      end

      def new
        @letter = @patient.letters.new
        @letter.build_recipient
        @letter.recipient.build_address
      end

      def create
        @letter = @patient.letters.new(letter_params)

        if @letter.save
          redirect_to patient_letters_letters_path(@patient),
            notice: t(".success", model_name: "Letter")
        else
          flash[:error] = t(".failed", model_name: "Letter")
          render :new
        end
      end

      def show
        @letter = @patient.letters.find(params[:id])
      end

      def edit
        @letter = @patient.letters.find(params[:id])
        @letter.build_recipient if @letter.recipient.blank?
        @letter.recipient.build_address if @letter.recipient.address.blank?
      end

      def update
        @letter = @patient.letters.find(params[:id])
        if @letter.update(letter_params)
          redirect_to patient_letters_letters_path(@patient),
            notice: t(".success", model_name: "Letter")
        else
          flash[:error] = t(".failed", model_name: "Letter")
          render :edit
        end
      end

      private

      def letter_params
        decorate(params)
          .require(:letters_letter)
          .permit(attributes)
          .remove_address_if_not_needed
          .merge(by: current_user)
      end

      def attributes
        [
          :letterhead_id, :author_id, :description, :issued_on,
          :salutation, :body, :notes,
          recipient_attributes: [
            :id, :name, :source_type, :source_id,
            address_attributes: [
              :id, :street_1, :street_2, :city, :county, :postcode, :country, :_destroy
            ]
          ]
        ]
      end

      def decorate(params)
        AddressCleaning.new(params)
      end

      class AddressCleaning < SmartDelegator
        def remove_address_if_not_needed
          if @object[:recipient_attributes][:source_type].present?
            @object[:recipient_attributes][:address_attributes][:_destroy] = "1"
          end
          @object
        end
      end
    end
  end
end