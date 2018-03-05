# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe RolesUser, type: :model do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :role }
    it { is_expected.to respond_to(:id) }
  end
end
