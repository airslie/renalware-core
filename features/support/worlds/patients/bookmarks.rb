module World
  module Patients
    module Bookmarks
      module Domain
        # @section commands
        #
        def bookmark_patient(user, patient_given_name, patient_family_name)
          create_bookmark(user, patient_given_name, patient_family_name)
        end

        def create_bookmark(user, patient_given_name, patient_family_name)
          user = Renalware::Patients.cast_user(user)
          patient = find_patient_by_name(patient_given_name, patient_family_name)

          Renalware::Patients::Bookmark.create!(user: user, patient: patient)
        end

        def delete_bookmark(user, patient_given_name, patient_family_name)
          patient = find_patient_by_name(patient_given_name, patient_family_name)
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

        def bookmark_patient(user, patient_given_name, patient_family_name)
          login_and_visit_patient(user, patient_given_name, patient_family_name)

          find("a", text: "Bookmark this patient").trigger("click")

          expect(page).to have_css("div.success")
        end

        def delete_bookmark(user, patient_given_name, patient_family_name)
          login_and_visit_patient(user, patient_given_name, patient_family_name)

          find("a", text: "Remove from bookmarks").trigger("click")

          expect(page).to have_css("div.success")
        end

        private

        def login_and_visit_patient(user, patient_given_name, patient_family_name)
          login_as user
          patient = find_patient_by_name(patient_given_name, patient_family_name)
          visit patient_path(id: patient.id)
        end
      end
    end
  end
end
