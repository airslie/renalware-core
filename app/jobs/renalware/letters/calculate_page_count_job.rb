# frozen_string_literal: true

require_dependency "renalware/letters"
require "pdf/reader"

module Renalware
  module Letters
    # This class is both a Wispler listener (subscribing to ApproveLetter events) and an ActiveJob.
    # Should be configured in the broadcast_subscription_map to listen to events from ApproveLetter
    # and be invoked aysnchronously via a background queue ie delayed_job.
    #
    # We generate a PDF version of the letter (or retrieve it from the cache) and inspect it
    # using a PDF tool to get the page count. We then save that away to the letters table.
    #
    # The page count is usefult when printing letters - letters with the same page count can be
    # printed together and fed into an envlope stuffer with the same page count setting eg 2
    # (address vocer sheet + duplex printed letter). Most of the time page count will be 1,
    # but the page count setting on the printer will be 2 becuase of the additional address cover
    # sheet.
    class CalculatePageCountJob < ApplicationJob
      # This method is the name of an event raised elsewhere by a Wisper publisher.
      def letter_approved(letter)
        reader = PDF::Reader.new(pdf_data_for(letter))
        letter.update_column(:page_count, reader.page_count)
      end

      private

      def pdf_data_for(letter)
        letter_presenter = LetterPresenter.new(letter)
        StringIO.new(PdfRenderer.call(letter_presenter))
      end
    end
  end
end
