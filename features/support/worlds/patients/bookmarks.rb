module World
  module Patients
    module Bookmarks
      module Domain
        # @section commands
        #
        def bookmark_patient(user, patient_given_name, patient_family_name)
          user = Renalware::Patients.cast_user(user)
          patient = find_patient_by_name(patient_given_name, patient_family_name)

          Renalware::Patients::Bookmark.create!(user: user, patient: patient)
        end

        # @section expectations
        #
        def expect_user_to_have_patients_in_bookmarks(user, patients)
          user = Renalware::Patients.cast_user(user)
          expect(user.patients).to eq(patients)
        end
      end

      module Web
        include Domain

        def bookmark_patient(user, patient_given_name, patient_family_name)
          login_as user

          patient = find_patient_by_name(patient_given_name, patient_family_name)

          visit patient_path(id: patient.id)

          find("a", text: "Bookmark this patient").trigger("click")

          expect(page).to have_css("div.success")
        end
      end
    end
  end
end
