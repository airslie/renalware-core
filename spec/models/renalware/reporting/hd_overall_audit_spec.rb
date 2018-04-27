# frozen_string_literal: true

require "rails_helper"

module Renalware
  # HD Overall Audit is a materialized view
  RSpec.describe "HD Overall Audit", type: :model do
    include PatientsSpecHelper

    let(:user) { create(:user) }
    let(:view_name) { "reporting_hd_overall_audit" }
    let(:unit1){ create(:hospital_unit, name: "Unit1") }
    let(:unit2){ create(:hospital_unit, name: "Unit2") }

    describe "json from hd_overall_audit materialized view" do
      describe ":data" do
        subject(:data) do
          Scenic.database.refresh_materialized_view(view_name)
          json = Reporting::FetchAuditJson.call(view_name)
          JSON.parse(json)["data"]&.map(&:symbolize_keys)
        end

        context "when there are no rows" do
          it { is_expected.to be_nil }
        end

        # describe "#patient_count" do
        #   before do
        #     create(
        #       :hd_patient_statistics,
        #       month: 1,
        #       year: 2018,
        #       hospital_unit: hospital_unit
        #     )
        #   end
        # end

        # describe "#patient_count" do
        #   subject{ data.map{ |x| x[:name] } }
        #   before do
        #     create(
        #       :hd_patient_statistics,
        #       month: 1,
        #       year: 2018,
        #       hospital_unit: hospital_unit
        #     )
        #     create(
        #       :hd_patient_statistics,
        #       month: 1,
        #       year: 2018,
        #       hospital_unit: hospital_unit
        #     )
        #   end

        #   it { is_expected.to eq(["Unit1"]) }
        #     # is_expected.to eq(
        #     #   [
        #     #     {
        #     #       name: "Unit1",
        #     #       patient_count: 2,
        #     #       percentage_hb_gt_100: 0,
        #     #       percentage_urr_gt_65: 0,
        #     #       percentage_phosphate_lt_1_8: 0,
        #     #       percentage_access_fistula_or_graft: 0,
        #     #       avg_missed_hd_time: 0,
        #     #       pct_shortfall_gt_5_pct: 0.0
        #     #     }
        #     #   ]
        #     #)
        #  # end
        # end

        context "when there are two hd_patient_statistics row with limited data" do
          before do
            create_list(
              :hd_patient_statistics, 2,
              month: 1,
              year: 2018,
              hospital_unit: unit1
            )
            create_list(
              :hd_patient_statistics, 2,
              month: 2,
              year: 2018,
              hospital_unit: unit1
            )
            create_list(
              :hd_patient_statistics, 2,
              month: 1,
              year: 2018,
              hospital_unit: unit2
            )
          end

          it do
            is_expected.to eq(
              [
                {
                  name: "Unit1",
                  year: 2018,
                  month: 1,
                  patient_count: 2,
                  avg_missed_hd_time: 0,
                  pct_shortfall_gt_5_pct: 0.0,
                  pct_missed_sessions_gt_10_pct: 0,
                  percentage_hgb_gt_100: 0,
                  percentage_hgb_gt_130: 0,
                  percentage_urr_gt_64: 0,
                  percentage_urr_gt_69: 0,
                  percentage_pth_lt_300: 0,
                  percentage_phosphate_lt_1_8: 0,
                  percentage_access_fistula_or_graft: "TBC"
                },
                {
                  name: "Unit1",
                  year: 2018,
                  month: 2,
                  patient_count: 2,
                  avg_missed_hd_time: 0,
                  pct_shortfall_gt_5_pct: 0.0,
                  pct_missed_sessions_gt_10_pct: 0,
                  percentage_hgb_gt_100: 0,
                  percentage_hgb_gt_130: 0,
                  percentage_urr_gt_64: 0,
                  percentage_urr_gt_69: 0,
                  percentage_pth_lt_300: 0,
                  percentage_phosphate_lt_1_8: 0,
                  percentage_access_fistula_or_graft: "TBC"
                },
                {
                  name: "Unit2",
                  year: 2018,
                  month: 1,
                  patient_count: 2,
                  avg_missed_hd_time: 0,
                  pct_shortfall_gt_5_pct: 0.0,
                  pct_missed_sessions_gt_10_pct: 0,
                  percentage_hgb_gt_100: 0,
                  percentage_hgb_gt_130: 0,
                  percentage_urr_gt_64: 0,
                  percentage_urr_gt_69: 0,
                  percentage_pth_lt_300: 0,
                  percentage_phosphate_lt_1_8: 0,
                  percentage_access_fistula_or_graft: "TBC"
                }
              ]
            )
          end
        end
      end
    end
  end
end
