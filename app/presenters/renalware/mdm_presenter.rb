module Renalware
  class MDMPresenter
    attr_reader :patient, :view_context

    def initialize(patient:, view_context:)
      @patient = patient
      @view_context = view_context
    end

    def pathology
      @pathology ||= begin
        table_view = Pathology::HistoricalObservationResults::HTMLTableView.new(view_context)
        presenter = Pathology::HistoricalObservationResults::Presenter.new
        pathology_patient = Renalware::Pathology.cast_patient(patient)
        Pathology::ViewObservationResults.new(pathology_patient.observations, presenter).call
        OpenStruct.new(table: table_view, rows: presenter.view_model)
      end
    end

    def prescriptions
      @prescriptions ||= begin
        Medications::PrescriptionsQuery.new(relation: patient.prescriptions.current)
          .call
          .with_created_by
          .with_medication_route
          .with_drugs
          .with_termination
          .map { |prescrip| Medications::PrescriptionPresenter.new(prescrip) }
      end
    end

    def letters
      patient_ = Renalware::Letters.cast_patient(patient)
      letters_ = patient_.letters
                         .order(issued_on: :desc)
                         .with_main_recipient
                         .with_letterhead
                         .with_author
                         .with_event
                         .with_patient
                         .limit(6)

      CollectionPresenter.new(letters_, Renalware::Letters::LetterPresenterFactory)
    end
  end
end
