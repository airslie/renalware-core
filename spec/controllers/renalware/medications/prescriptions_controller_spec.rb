require "rails-controller-testing"

module Renalware
  module Medications
    describe PrescriptionsController do
      describe "#pdf_title" do
        it "filters the PDF to HD prescriptions for the HD print scope" do
          params = ActionController::Parameters.new(print_scope: "hd")

          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:pdf_title)).to eq("Medications to be given on HD")
          expect(params[:q][:administer_on_hd_eq]).to be(true)
        end

        it "filters the PDF to outpatient prescriptions for the outpatient print scope" do
          params = ActionController::Parameters.new(print_scope: "outpatient")

          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:pdf_title)).to eq("Medications to be given as Outpatient")
          expect(params[:q][:give_as_outpatient_eq]).to be(true)
        end

        it "retains the legacy hd_only parameter" do
          params = ActionController::Parameters.new(hd_only: "true")

          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:pdf_title)).to eq("Medications to be given on HD")
          expect(params[:q][:administer_on_hd_eq]).to be(true)
        end
      end
    end
  end
end
