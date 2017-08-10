require "rails_helper"

module Renalware::Messaging
  describe Message, type: :model do
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:patient) }
    it { is_expected.to validate_presence_of(:sent_at) }
    it { is_expected.to have_db_index(:patient_id) }
    it { is_expected.to have_db_index(:author_id) }
    it { is_expected.to have_db_index(:subject) }
    it { is_expected.to have_many(:receipts) }
    it { is_expected.to have_many(:recipients).through(:receipts) }
    it { is_expected.to belong_to(:patient) }
    it { is_expected.to belong_to(:author) }
  end
end
