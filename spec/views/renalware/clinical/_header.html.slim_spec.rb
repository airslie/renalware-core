require "rails_helper"

describe "renalware/clinical/header" do
  let(:patient) { create(:patient) }
  let(:presenter) { Renalware::Clinical::HeaderPresenter.new(patient) }

  def t(key)
    I18n.translate(key, scope: "renalware.clinical.header")
  end

  it "displays the correct latest clinical observations" do
    create(
      :clinic_visit,
      patient_id: patient.id,
      weight: 100.99,
      height: 1.99,
      systolic_bp: 123,
      diastolic_bp: 91
    )
    latest_pathology = double(:latest_pathology)
    %i(hgb cre mdrd pot egfr ure).each do |code|
      allow(latest_pathology).to receive("#{code}_result").and_return "#{code}_result"
      allow(latest_pathology).to receive("#{code}_observed_at").and_return Time.zone.now
    end
    allow(presenter).to receive(:latest_pathology).and_return(latest_pathology)
    render partial: "renalware/clinical/header", locals: { patient: presenter }

    expect(rendered).to include t("blood_pressure")
    expect(rendered).to include t("weight")
    expect(rendered).to include t("height")
    expect(rendered).to include t("bmi")
    expect(rendered).to include("100.99")
    expect(rendered).to include("1.99")
    expect(rendered).to include("123/91")
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
