# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    # Perform full DM+D synchronisation
    # Safe to run multiple times.
    #
    # @see Synchronisers::FullSynchroniser
    class SynchroniserJob < ApplicationJob
      def perform_now
        Synchronisers::FullSynchroniser.new.call
      end
    end
  end
end