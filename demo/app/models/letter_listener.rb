# frozen_string_literal: true

# This demo letter listener had been wired to receive the letter_approved broadcast events in the
# broadcast_subscription_map (see config/initializers/renalware.rb) and it illustrates some
# actions that can be taken after the letter has been approved.
# Its worth mentioning that you might like to defer some actions into the future, to allow
# a cooling off period, eg 2 hours, within which the letter can be revoked if it was decided an
# error was made. In these instances, we will need to store the ActiveJob.id of any future-scheduled
# jobs so we can find and try them if the letter is revoked within the period. If the period has
# elapsed and the job(s) have been processed, then a replacement letter will need to be sent.
# Somewhere in the UI we need to indicate that future jobs where or where not cancelled.
#
# Examples of things we could do here
# - copy the letter in to folder for later submission to CRS
# - send the letter in a HL7 or FHIR message to the hospital TIE
# - send the letter in a FHIR message to Patient Knows Best
# - send the letter to the practice via the MESH API (eg with GPConnect 'Send Document' workflow)
# - email the letter to the practice
class LetterListener
  def letter_approved(letter)
    # email_letter_to_practice(letter)
    # send_hl7_mdm_message_to_hospital_tie_via_mirth(letter)
    enqueue_a_scheduled_job_to_deliver_to_gp_over_mesh(letter)
  end

  private

  def enqueue_a_scheduled_job_to_deliver_to_gp_over_mesh(letter)
    mesh = Renalware::Letters::Transports::Mesh
    mesh::Transmission.transaction do
      transmission = mesh::Transmission.create!(letter: letter)
      job = mesh::SendMessageJob.set(wait: 5.minutes).perform_later(transmission)
      job.job_id
    end
  end

  def email_letter_to_practice(letter)
    # At KCH for example, we email the letter to the practice on approval, provided the practice
    # has an email address.
    # EmailLetterToPractice uses deliver_later so email delivery effectively asynchronous
    Renalware::Letters::Delivery::Email::EmailLetterToPractice.call(letter)
  end

  # This mechanism puts te letter into renalware.outgoing_documents and then Mirth polls this table
  # and sends the letter as e.g. an MDM HL7 message to the configured location - for example the
  # hospital TIE.
  def send_hl7_mdm_message_to_hospital_tie_via_mirth(letter)
    Renalware::Feeds::OutgoingDocument.create!(renderable: letter, by: letter.approved_by)
  end
end
