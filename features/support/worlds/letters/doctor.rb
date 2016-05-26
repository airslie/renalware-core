module World
  module Letters::Doctor
    module Domain
      # @section expectations
      #
      def expect_doctor_can_review_letter(patient:, doctor:)
        letter_doctor = Renalware::Letters.cast_doctor(doctor)
        letter = simple_letter_for(patient)
        result = letter_doctor.letters.reviewable.include?(letter)

        expect(result).to be_truthy
      end
    end

    module Web
      include Domain
    end
  end
end
