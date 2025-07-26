class Renalware::Patients::TimelineController < Renalware::BaseController
  def show
    authorize Renalware::Patients::Timeline
    render Views::Patients::Timeline::Show.new(patient:, page:)
  end
end
