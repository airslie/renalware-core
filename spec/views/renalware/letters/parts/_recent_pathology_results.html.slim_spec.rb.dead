# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe "renalware/letters/parts/_recent_pathology_results", type: :view do
    helper(Renalware::LettersHelper)
    helper(Renalware::AttributeNameHelper)

    let(:partial) { "renalware/letters/parts/recent_pathology_results" }
    let(:part) { Letters::Part::RecentPathologyResults.new(nil, letter, nil) }
    let(:letter) { instance_double(Letters::Letter, pathology_snapshot: pathology_snapshot) }

    subject {
      render partial: partial, locals: { recent_pathology_results: part }
      rendered
    }

    context "when there are no pathology results" do
      let(:pathology_snapshot) { {} }

      it { is_expected.to include("None") }
    end

    # Letter path is
    # HGB PLT WBC URE CRE EGFR POT NA BIC CCA PHOS ALB BIL AST GGT ALP CHOL FER HBA BGLU PTHI
    context "when a pathology_snapshot has results 3 results on different days" do
      let(:pathology_snapshot) do
        {
          "CCA": {
            "result": "2.24",
            "observed_at": "2018-03-01T13:56:00"
          },
          "CRE": {
            "result": "221",
            "observed_at": "2018-02-02T13:56:00"
          },
          "PHOS": {
            "result": "0.85",
            "observed_at": "2018-01-03T13:56:00"
          }
        }
      end

      it {
        is_expected.to(
          include("01-Mar-2018: CCA 2.24; 02-Feb-2018: CRE 221; 03-Jan-2018: PHOS 0.85;")
        )
      }
    end

    context "when a pathology_snapshot has 3 results on the same day" do
      let(:pathology_snapshot) do
        {
          "CCA": {
            "result": "2.24",
            "observed_at": "2018-02-02T13:56:00"
          },
          "CRE": {
            "result": "221",
            "observed_at": "2018-02-02T13:56:00"
          },
          "PHOS": {
            "result": "0.85",
            "observed_at": "2018-02-02T13:56:00"
          }
        }
      end

      it {
        is_expected.to(
          include("02-Feb-2018: CRE 221, CCA 2.24, PHOS 0.85;")
        )
      }
    end

    context "when a pathology_snapshot has 3 results across 2 days" do
      let(:pathology_snapshot) do
        {
          "CCA": {
            "result": "2.24",
            "observed_at": "2018-02-02T13:56:00"
          },
          "PHOS": {
            "result": "0.85",
            "observed_at": "2018-04-01T13:56:00"
          },
          "CRE": {
            "result": "221",
            "observed_at": "2018-04-01T13:56:00"
          }
        }
      end

      it {
        is_expected.to(
          include("01-Apr-2018: CRE 221, PHOS 0.85; 02-Feb-2018: CCA 2.24;")
        )
      }
    end
  end
end
