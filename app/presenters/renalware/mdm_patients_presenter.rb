module Renalware
  # Presenter formatting a collection of patients for use behind any MDM Patients listing.
  class MDMPatientsPresenter
    include PresenterHelper
    attr_reader :patients, :view_proc, :page_title
    def initialize(patients:, view_proc:, page_title:)
      @view_proc = view_proc
      @patients = present(patients, MDMPatientPresenter)
      @page_title = page_title
    end
  end
end
