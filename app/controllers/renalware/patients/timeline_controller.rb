class Renalware::Patients::TimelineController < Renalware::BaseController
  def show
    authorize Renalware::Patients::Timeline
    render Views::Patients::Timeline::Show.new(patient:, page: params[:page])
  end

  private

  def patient
    Renalware::Patient.find params[:patient_id]
  end
end
