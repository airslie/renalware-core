# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Transplants
    describe RecipientWorkup do
      it_behaves_like "an Accountable model"
      it { is_expected.to belong_to(:patient).touch(true) }
    end
  end
end
