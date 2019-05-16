# frozen_string_literal: true

require "rails_helper"
require "builder"

describe "Diagnoses element" do
  helper(Renalware::ApplicationHelper)

  def partial_content(patient_presenter)
    render partial: "renalware/api/ukrdc/patients/diagnoses.xml.builder",
           locals: {
             patient: patient_presenter,
             builder: Builder::XmlMarkup.new
           }
  end

  def build_stubbed_death_modality(patient)
    death = build_stubbed(:modality_description, :death)
      .becomes(Renalware::Deaths::ModalityDescription)
    modality = build_stubbed(
      :modality,
      patient: patient,
      description: death,
      started_on: Time.zone.now
    )
    allow(patient).to receive(:current_modality).and_return(modality)
  end

  context "when the patient is deceased" do
    context "when the patient has no first cause of death" do
      it "does not include a cause of death" do
        patient = build_stubbed(:patient, family_name: "Jones", local_patient_id: "1")
        build_stubbed_death_modality(patient)
        presenter = Renalware::UKRDC::PatientPresenter.new(patient)

        xml = partial_content(presenter)

        expect(xml).not_to include("<CauseOfDeath>")
      end
    end

    context "when the patient has a first cause of death" do
      it "includes a cause of death" do
        patient = build_stubbed(:patient,
                                family_name: "Jones",
                                local_patient_id: "1",
                                first_cause: build_stubbed(:cause_of_death)
                               )
        build_stubbed_death_modality(patient)
        presenter = Renalware::UKRDC::PatientPresenter.new(patient)

        xml = partial_content(presenter)

        expect(xml).to include("<CauseOfDeath")
      end
    end
  end
end
