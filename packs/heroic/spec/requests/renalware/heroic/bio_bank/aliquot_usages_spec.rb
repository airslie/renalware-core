# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Aliquot Usages" do
  let(:user) { @current_user }
  let(:patient) { create(:patient, by: user) }
  let(:sample) { create(:bio_bank_sample, :dna, patient: patient, by: user) }
  let(:aliquot) { create(:bio_bank_aliquot, sample: sample, by: user) }

  describe "GET new" do
    it "renders the new form" do
      get heroic.new_bio_bank_aliquot_usage_path(aliquot)

      expect(response).to be_successful
    end
  end

  describe "POST create" do
    context "when attributes are valid" do
      it "creates a new usage" do
        params = {
          usage: {
            usable_id: aliquot.id,
            study_name: "Study1",
            notes: "notes",
            used_at: "31-01-2019 02:00"
          }
        }

        post(heroic.bio_bank_aliquot_usage_path(aliquot), params: params)

        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful

        usage = aliquot.reload.usage
        expect(usage).to have_attributes(
          study_name: "Study1",
          notes: "notes",
          used_at: Time.zone.parse("31-01-2019 02:00")
        )
      end
    end

    context "when attributes are invalid" do
      it "returns validation error" do
        params = {
          usage: {
            usable_id: sample.id,
            study_name: "Study1",
            notes: "notes"
          }
        }

        post(heroic.bio_bank_aliquot_usage_path(aliquot), params: params)

        expect(response).to be_successful
      end
    end
  end

  describe "GET edit" do
    it "displays a form to edit a usage" do
      usage = create(:bio_bank_usage, usable: aliquot, by: user)

      get heroic.edit_bio_bank_aliquot_usage_path(aliquot, usage)

      expect(response).to be_successful
    end
  end

  describe "PATCH update" do
    context "when there are no validation errors" do
      it "updates the usage" do
        usage = create(:bio_bank_usage, usable: aliquot, by: user)
        params = {
          usage: {
            study_name: "Study123",
            notes: "notes1",
            used_at: "31-01-2019 02:00"
          }
        }

        patch heroic.bio_bank_aliquot_usage_path(aliquot, usage), params: params

        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful

        expect(usage.reload).to have_attributes(
          study_name: "Study123",
          notes: "notes1",
          used_at: Time.zone.parse("31-01-2019 02:00")
        )
      end
    end

    context "when there are validation errors" do
      it "re-renders the edit form" do
        usage = create(:bio_bank_usage, usable: aliquot, by: user)
        params = { usage: { used_at: nil } }

        patch heroic.bio_bank_aliquot_usage_path(aliquot, usage), params: params

        expect(response).to be_successful
      end
    end
  end

  describe "DELETE destroy" do
    it "soft deletes the usage" do
      usage = create(:bio_bank_usage, usable: aliquot, by: user)

      delete heroic.bio_bank_aliquot_usage_path(aliquot, usage)

      expect(response).to be_redirect
      follow_redirect!
      expect(response).to be_successful

      expect(aliquot.reload.usage).to be_nil
    end
  end
end
