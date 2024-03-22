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
    Renalware::Letters::Delivery::Email::EmailLetterToPractice.call(letter)

    # MSE (pre-ToC) use HL7 transmission of letters via outgoing_documents table and Mirth
    Renalware::Feeds::OutgoingDocument.create!(renderable: letter, by: letter.approved_by)

    queue_a_mesh_transmission_for_async_delivery_to_gp_over_mesh(letter)
  end

  private

  def queue_a_mesh_transmission_for_async_delivery_to_gp_over_mesh(letter)
    transmission = Renalware::Letters::Transports::Mesh::Transmission.create!(letter: letter)
    Renalware::Letters::Transports::Mesh::SendMessageJob.perform_later(transmission)
  end
end
