require "rails_helper"

describe "renalware/clinical/header" do
  let(:patient) { create(:patient) }

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
    render partial: "renalware/clinical/header", locals: { patient: patient }

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

    current_pathology = double(:current_pathology, path)

    presenter = Renalware::Clinical::HeaderPresenter.new(patient)
    allow(presenter).to receive(:current_pathology).and_return(current_pathology)
    render partial: "renalware/clinical/header", locals: { patient: patient, header: presenter }

    path_codes.each do |code|
      expect(rendered).to include I18n.translate(code, scope: "renalware.clinical.header")
      expect(rendered).to include "#{code}_result"
      expect(rendered).to include(I18n.l(date))
    end
  end
end
