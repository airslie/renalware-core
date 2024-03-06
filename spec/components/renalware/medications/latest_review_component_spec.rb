# frozen_string_literal: true

require "rails_helper"

describe Renalware::Medications::LatestReviewComponent, type: :component do
  it "renders nothing if the patient has no medication reviews" do
    user = create(:user)
    patient = create(:patient, by: user)
    component = described_class.new(patient: patient)

    render_inline(component)

    expect(component.render?).to be(false)
    expect(page.text).to eq("")
  end

  describe "displays details about the last medication review the patient had" do
    before do
      yaml = <<-YAML
        renalware:
          medications:
            latest_review_component:
              title: Text1 by %{user} on %{date}
              compact_title: Text2 %{date} by %{user}
      YAML
      I18n.t("renalware/medications/latest_review_component") # load first
      I18n.backend.store_translations(:en, YAML.safe_load(yaml)) # then replace
    end

    {
      false => "Text1 by A Person (Pos) on 01-Jan-2021",
      true => "Text2 01-Jan-2021 by A Person (Pos)"
    }.each do |compact, title|
      context "when the compact is #{compact}" do
        it "displays the correct format defined by the component's i18n yml" do
          user = create(:user, professional_position: "Pos", signature: "A Person")
          patient = create(:patient, by: user)
          create(
            :medication_review,
            patient: patient,
            date_time: "2021-01-01 11:01:01",
            by: user
          )

          # Set the config value to lots of months ago so we don't have to worry about this
          # test failing at some point
          allow(Renalware.config)
            .to receive(:medication_review_max_age_in_months)
            .and_return(10000)

          render_inline(
            described_class.new(
              patient: patient,
              compact: compact
            )
          )

          expect(page).to have_content(title)
        end
      end
    end
  end
end
