# frozen_string_literal: true

# This listener had been wired to receive the letter_approved broadcast events in the
# broadcast_subscription_map.
# See config/initializers/renalware.rb
#
class LetterListener
  def letter_approved(letter)
    # At KCH, we email the letter to the practice on approval, provided the practice
    # has an email address.
    # EmailLetterToPractice uses deliver_later so email delivery effectively asynchronous
    Renalware::Letters::Delivery::EmailLetterToPractice.call(letter)
  end
end
