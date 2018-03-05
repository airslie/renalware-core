# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe System::UserFeedback, type: :model do
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:comment) }
    it { is_expected.to have_db_index(:author_id) }
    it { is_expected.to enumerize(:category).with_default(:general) }
  end
end
