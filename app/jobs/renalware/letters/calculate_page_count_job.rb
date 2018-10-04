# frozen_string_literal: true

require_dependency "renalware/letters"
require "pdf/reader"
require "attr_extras"

module Renalware
  module Letters
    # This class is both a Wispler listener (subscribing to ApproveLetter events) and an ActiveJob.
    # Should be configured in the broadcast_subscription_map to listen to events from ApproveLetter
    # and be invoked aysnchronously via a background queue ie delayed_job.
    #
    # We generate a PDF version of the letter (or retrieve it from the cache) and inspect it
    # using a PDF tool to get the page count. We then save that away to the letters table.
    #
    # The page count is useful when printing letters; letters with the same page count can be
    # printed together and fed into an envelope stuffer with the same page count setting eg 2
    # (address cover sheet + duplex printed letter). Most of the time page count will be 1,
    # but the page count setting on the printer will be 2 because of the additional address cover
    # sheet.
    class CalculatePageCountJob < ApplicationJob
      pattr_initialize :letter

      # This method is the name of an event raised elsewhere by a Wisper publisher.
      # It needs to be a class method in order to be invoked asynchronously by delayed_job
      def self.letter_approved(letter)
        new(letter).call
      end

      def call
        letter.update_column(:page_count, pdf_reader.page_count)
      end

      private

      def pdf_reader
        PDF::Reader.new(pdf_data)
      end

      def pdf_data
        letter_presenter = LetterPresenter.new(letter)
        StringIO.new(PdfRenderer.call(letter_presenter))
      end
    end
  end
end
