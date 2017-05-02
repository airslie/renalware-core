require "rails_helper"

describe Renalware::Clinics::BuildVisitFromAppointment, type: :model do
  describe "#call" do
    it "creates a new clinic visit based on the appointment" do
      patient = Renalware::Clinics.cast_patient(build(:patient))
      allow(patient).to receive(:destroyed?).and_return(false)
      appointment = build_stubbed(:appointment,
                                  patient: patient,
                                  clinic: build_stubbed(:clinic),
                                  starts_at: Time.zone.now)

      visit = described_class.new(appointment).call

      expect(visit).to be_a(Renalware::Clinics::ClinicVisit)
      expect(visit.patient_id).to eq(appointment.patient_id)
      expect(visit.clinic_id).to eq(appointment.clinic_id)
      expect(visit.date).to eq(appointment.starts_at.to_date)
      expect(visit.time).to eq(appointment.starts_at.to_time)
    end
  end
end
