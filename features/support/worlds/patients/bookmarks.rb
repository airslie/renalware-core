module World
  module Patients
    module Bookmarks
      module Domain
        # @section helpers
        #
        def find_patient(given_name, family_name)
          Renalware::Patient.find_by!(
            given_name: given_name, family_name: family_name
          )
        end

        # @section commands
        #
        def record_bookmark(user, patient_given_name, patient_family_name)
          create_bookmark(user, patient_given_name, patient_family_name)
        end

        def create_bookmark(user, patient_given_name, patient_family_name)
          patient = find_patient(patient_given_name, patient_family_name)
          Renalware::Patients::Bookmark.create!(user: user, patient: patient)
        end

        def delete_bookmark(user, patient_given_name, patient_family_name)
          patient = find_patient(patient_given_name, patient_family_name)
          user = Renalware::Patients.cast_user(user)

          bookmark = user.bookmarks.find_by(patient: patient)
          bookmark.destroy
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

        def record_bookmark(user, patient_given_name, patient_family_name)
          login_as user

          patient = find_patient(patient_given_name, patient_family_name)

          visit patient_path(id: patient.id)

          find("a", text: "Bookmark this patient").trigger("click")
          wait_for_ajax

          expect(page).to have_content("You have successfully added a new bookmark.")
        end

        def delete_bookmark(user, patient_given_name, patient_family_name)
          login_as user

          patient = find_patient(patient_given_name, patient_family_name)

          visit patient_path(id: patient.id)

          find("a", text: "Remove from Bookmarks").trigger("click")
          wait_for_ajax

          expect(page).to have_content("You have successfully added a new bookmark.")
        end
      end
    end
  end
end
