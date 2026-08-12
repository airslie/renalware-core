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

        it "falls back to the standard medication list when outpatient admin is disabled" do
          params = ActionController::Parameters.new(print_scope: "outpatient")

          allow(Renalware.config)
            .to receive(:outpatient_prescription_administration_enabled)
            .and_return(false)
          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:pdf_title)).to eq("Medication List")
          expect(params[:q]).to be_empty
        end

        it "retains the legacy hd_only parameter" do
          params = ActionController::Parameters.new(hd_only: "true")

          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:pdf_title)).to eq("Medications to be given on HD")
          expect(params[:q][:administer_on_hd_eq]).to be(true)
        end
      end

      describe "#render_current_medications_section?" do
        it "renders the section for all drugs" do
          params = ActionController::Parameters.new(print_scope: "all")

          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:render_current_medications_section?)).to be(true)
        end

        it "does not render the section for HD drugs" do
          params = ActionController::Parameters.new(print_scope: "hd")

          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:render_current_medications_section?)).to be(false)
        end

        it "does not render the section for outpatient drugs" do
          params = ActionController::Parameters.new(print_scope: "outpatient")

          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:render_current_medications_section?)).to be(false)
        end

        it "renders the section for outpatient drugs when outpatient administration is disabled" do
          params = ActionController::Parameters.new(print_scope: "outpatient")

          allow(Renalware.config)
            .to receive(:outpatient_prescription_administration_enabled)
            .and_return(false)
          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:render_current_medications_section?)).to be(true)
        end
      end

      describe "#render_empty_hd_prescriptions_section?" do
        it "renders an empty HD prescriptions section only for HD drugs" do
          params = ActionController::Parameters.new(print_scope: "hd")

          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:render_empty_hd_prescriptions_section?)).to be(true)
        end

        it "does not render an empty HD prescriptions section for all drugs" do
          params = ActionController::Parameters.new(print_scope: "all")

          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:render_empty_hd_prescriptions_section?)).to be(false)
        end
      end

      describe "#render_empty_outpatient_prescriptions_section?" do
        it "renders an empty outpatient prescriptions section only for outpatient drugs" do
          params = ActionController::Parameters.new(print_scope: "outpatient")

          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:render_empty_outpatient_prescriptions_section?)).to be(true)
        end

        it "does not render an empty outpatient section when outpatient admin is disabled" do
          params = ActionController::Parameters.new(print_scope: "outpatient")

          allow(Renalware.config)
            .to receive(:outpatient_prescription_administration_enabled)
            .and_return(false)
          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:render_empty_outpatient_prescriptions_section?)).to be(false)
        end

        it "does not render an empty outpatient prescriptions section for all drugs" do
          params = ActionController::Parameters.new(print_scope: "all")

          allow(controller).to receive(:params).and_return(params)

          expect(controller.send(:render_empty_outpatient_prescriptions_section?)).to be(false)
        end
      end
    end
  end
end
