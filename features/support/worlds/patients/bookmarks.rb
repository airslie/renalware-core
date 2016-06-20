module World
  module Patients
    module Bookmarks
      module Domain
        def record_bookmark(user, patient_given_name, patient_family_name)
          patient = Renalware::Patient.find_by!(
            given_name: patient_given_name, family_name: patient_family_name
          )

          Renalware::Patients::Bookmark.create!(user: user, patient: patient)
        end

        def expect_user_to_have_patients_in_bookmarks(user, patients)
          user = Renalware::Patients.cast_user(user)
          expect(user.patients).to eq(patients)
        end
      end

      module Web
        include Domain
      end
    end
  end
end
