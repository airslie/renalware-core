# frozen_string_literal: true

module Renalware
  module System
    # Represents a URL to an online reference that a patient can view to get more information
    # about their condition or treatment. We can generate a QRCode for this URL at any point
    # eg for inserting into a letter.
    # A clinican can add these records through the admin UI or while creating a letter.
    # We could enhance at some point to fetch the og:title and og:description from the head of the
    # html document that is referenced, in order to prepopulate title and description.
    class OnlineReferenceLink < ApplicationRecord
      include Accountable

      validates(
        :url,
        presence: true,
        uniqueness: true,
        format: %r{\Ahttp(s{0,1})://.+}i # keeping it simple
      )
      validates :title, presence: true, uniqueness: true
    end
  end
end
