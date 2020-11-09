# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Patients
    describe SyncPracticesViaAPI do
      include ActiveJob::TestHelper

      describe "#call" do
        it "delegates to other API and download service object" do
        end
      end
    end
  end
end
