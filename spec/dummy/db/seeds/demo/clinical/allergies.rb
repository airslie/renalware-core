module Renalware
  log "Adding Allergies for Roger RABBIT" do

    class CreateAllergy
      def initialize
        @rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
        @user_id = Renalware::User.last.id
      end

      def call(on: Time.now - 2.weeks,
               allergy: "Lorem ipusm")
        Clinical::Allergy.new(
          patient_id: @rabbit.id,
          description: allergy,
          recorded_at: on,
          created_by_id: @user_id,
          updated_by_id: @user_id,
         ).save!
      end
    end

    CreateAllergy.new.call(on: Time.now - 6.months, allergy: "Carrots")
    CreateAllergy.new.call(on: Time.now - 1.month, allergy: "Penicillin")
  end
end
