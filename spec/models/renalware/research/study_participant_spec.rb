# frozen_string_literal: true

require "rails_helper"

module Renalware
  RSpec.describe Research::StudyParticipant, type: :model do
    it_behaves_like "an Accountable model"
    it_behaves_like "a Paranoid model"
    it { is_expected.to validate_presence_of :participant_id }

    describe "uniqueness" do
      subject{
        Research::StudyParticipant.new(
          participant_id: patient.id,
          study_id: study.id,
          joined_on: "2018-01-01"
        )
      }
      let(:study) { create(:research_study) }
      let(:patient) { create(:patient) }

      it { is_expected.to validate_uniqueness_of(:external_id) }
    end
  end
end
