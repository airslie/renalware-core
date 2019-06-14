# frozen_string_literal: true

require "rails_helper"

module Renalware
  module UKRDC
    module TreatmentTimeline
      describe GeneratorFactory do
        describe ".call" do
          subject { described_class.call(modality) }

          context "when the supplied modality has no explicit type" do
            let(:patient) { build_stubbed(:patient) }
            let(:description) { build_stubbed(:modality_description, name: "X", type: "") }
            let(:modality) { build_stubbed(:modality, description: description, patient: patient) }

            it { is_expected.to be_a(Generators::GenericTimeline) }
          end

          module Generators
            class TestMeTimeline
              pattr_initialize :modality
            end
          end

          context "when the supplied modality has a type and a custom generator" do
            let(:patient) { build_stubbed(:patient) }
            let(:description) do
              build_stubbed(
                :modality_description,
                name: "X",
                type: "Renalware::Test::MeModalityDescription"
              )
            end
            let(:modality) { build_stubbed(:modality, description: description, patient: patient) }

            it do
              is_expected.to be_a(
                Renalware::UKRDC::TreatmentTimeline::Generators::TestMeTimeline
              )
            end
          end

          context "when the supplied modality has a type but no custom generator" do
            let(:patient) { build_stubbed(:patient) }
            let(:description) do
              build_stubbed(
                :modality_description,
                name: "X",
                type: "Renalware::Test::BlaBlaModalityDescription"
              )
            end
            let(:modality) { build_stubbed(:modality, description: description, patient: patient) }

            it { is_expected.to be_a(Generators::GenericTimeline) }
          end
        end
      end
    end
  end
end