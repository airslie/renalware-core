# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Surveys
    describe Survey do
      it_behaves_like "a Paranoid model"
      it { is_expected.to have_many(:questions) }
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to have_db_index(:name) }
      it { is_expected.to have_db_index(:deleted_at) }

      describe "#uniqueness" do
        subject { Survey.new(name: "x", code: "x") }

        it { is_expected.to validate_uniqueness_of :name }
      end
    end
  end
end
