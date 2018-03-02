# frozen_string_literal: true

module Renalware
  # Presenter formatting a collection of patients for use behind any MDM Patients listing.
  class MDMPatientsPresenter
    include PresenterHelper
    attr_reader :patients, :view_proc, :page_title, :q
    def initialize(patients:,
                   view_proc:,
                   page_title:,
                   q:,
                   patient_presenter_class: nil)
      patient_presenter_class ||= MDMPatientPresenter
      @view_proc = view_proc
      @patients = present(patients, patient_presenter_class)
      @page_title = page_title
      @q = q
    end
  end
end
