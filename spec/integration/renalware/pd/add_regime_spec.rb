# require "rails_helper"

# module Renalware
#   module PD
#     RSpec.describe "Adding a regime", type: :request do
#       let(:patient) { create(:patient) }
#       let(:apd_regime) do
#         regime = build(:apd_regime, patient: patient) { |reg| reg.bags << build(:pd_regime_bag) }
#         regime.save!
#         regime
#       end
#       let(:capd_regime) do
#         regime = build(:capd_regime, patient: patient) { |reg| reg.bags << build(:pd_regime_bag) }
#         regime.save!
#         regime
#       end

#       describe "GET new" do
#         context "APD" do
#           context "when the patient has never had an APD regime" do
#             it "executes the #new action" do
#               get new_patient_pd_apd_regime_path(patient)

#               expect(response).to have_http_status(:success)
#             end
#           end

#           context "when the patient has a current CAPD regime and has never had an APD one" do
#             it "executes the #new action" do
#               capd_regime

#               get new_patient_pd_apd_regime_path(patient)

#               expect(response).to have_http_status(:success)
#             end
#           end

#           context "when the patient has a current APD" do
#             it "redirects to #edit so that the form will be pre-populated with the last "\
#                "known APD values" do
#               apd_regime

#               get new_patient_pd_apd_regime_path(patient)

#               expect(response).to have_http_status(:redirect)
#               expect(response).to redirect_to edit_patient_pd_regime_path(patient, apd_regime)
#             end
#           end

#           context "when the patient has a current CAPD regime but previously had an APD one" do
#             it "redirects to #edit so that the form will be pre-populated with the last "\
#                "known APD values" do
#               apd_regime
#               capd_regime # now current as created last

#               get new_patient_pd_apd_regime_path(patient)

#               expect(response).to have_http_status(:redirect)
#               expect(response).to redirect_to edit_patient_pd_regime_path(patient, apd_regime)
#             end
#           end
#         end
#       end
#     end
#   end
# end
