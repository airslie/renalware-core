require "rails_helper"

describe "renalware/clinical/header" do
  helper(Renalware::ApplicationHelper, Renalware::PatientHelper)
  let(:patient) { build_stubbed(:patient) }
  let(:visit) { build_stubbed(:clinic_visit, patient: patient, weight: 21.99) }
  let(:presenter) { Renalware::Clinical::HeaderPresenter.new(patient) }

  it "displays the correct latest clinical observations" do
    # path_codes = %i(weight height blood_pressure bmi)
  end

  it "displays the correct latest pathology" do
    path_codes = %i(hgb cre mdrd pot egfr ure)
    date = Time.zone.now.to_date
    path = path_codes.each_with_object({}) do |code, hash|
      hash[:"#{code}_result"] = "#{code}_result"
      hash[:"#{code}_observed_at"] = date
    end

    latest_pathology = double(:latest_pathology, path)

    allow(presenter).to receive(:latest_pathology).and_return(latest_pathology)
    render partial: "renalware/clinical/header", locals: { patient: presenter }

    path_codes.each do |code|
      expect(rendered).to include I18n.translate(code, scope: "renalware.clinical.header")
      expect(rendered).to include "#{code}_result"
      expect(rendered).to include(I18n.l(date))
    end
  end
end

# Solutions
# 1: brute force make it work with sql and ruby then augment with some caching
# 2: use observation_set approach like path - for caching, use clinicl_obseupdaed and
# patholog_onset_udupdated  dates (could be in patient_summary?)
# 3: use patient summary in some way
# 4. materialised view - NO
# 5. View - expensive
# it make sense to use path currentobs set
# so whuy noa a clini obs set?
# - risk (trigger not working - should we manually update over night also?)
# - view is more risk free - but at cost
