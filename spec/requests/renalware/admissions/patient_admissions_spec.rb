module Renalware
  describe "Listing admissions for the current patient" do
    let(:user) { create(:user) }
    let(:time) { Time.zone.now }
    let(:hospital_ward) { create(:hospital_ward, name: "Ward1") }
    let(:patient) { create(:patient, :minimal, by: user) }

    describe "GET #index" do
      it "paginates in reverse chronology and excludes other patients" do
        create_admissions
        create(:admissions_admission, by: user, reason_for_admission: "Other patient")

        get patient_admissions_path(patient)
        expect(response).to be_successful
        expect(response.body).to include("Admission 00", "Admission 19")
        expect(response.body).not_to include("Admission 20", "Other patient")

        get patient_admissions_path(patient), params: { page: 2, per_page: 1 }
        expect(response).to be_successful
        expect(response.body).to include("Admission 01")
        expect(response.body).not_to include("Admission 00", "Admission 02", "Other patient")
      end

      it "lists the patient's inpatient admissions" do
        create(:admissions_admission,
               by: user,
               patient:,
               admitted_on: Time.zone.today,
               admission_type: :unknown,
               reason_for_admission: "Reason1",
               hospital_ward:)

        get patient_admissions_path(patient)

        expect(response).to be_successful
        expect(response.body).to include("Inpatient Admissions")
        expect(response.body).to include("Reason1")
        expect(response.body).to include(hospital_ward.name)
      end
    end

    def create_admissions
      21.times do |index|
        create(:admissions_admission,
               by: user,
               patient:,
               admitted_on: index.days.ago.to_date,
               reason_for_admission: format("Admission %02d", index),
               hospital_ward:)
      end
    end
  end
end
