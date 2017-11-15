require_dependency "renalware/letters"

module Renalware
  module Letters
    class LetterFactory
      def initialize(patient, params = {})
        @params = LetterParamsProcessor.new(patient).call(params)
        @patient = Letters.cast_patient(patient)
        @default_ccs = []
      end

      def build
        @electronic_cc_recipient_ids = params.delete(:electronic_cc_recipient_ids)
        @letter = build_letter
        build_electronic_ccs
        include_primary_care_physician_as_default_main_recipient
        assign_default_ccs
        build_salutation
        letter.pathology_timestamp = Time.zone.now
        letter
      end

      def with_contacts_as_default_ccs
        @default_ccs = contacts_with_default_cc_option

        self
      end

      private

      attr_reader :patient, :letter, :params, :electronic_cc_recipient_ids

      def build_letter
        # We should not have to set the STI type manually here but in some circumstances
        # the type is not getting set by rails STI mechanism automatically - hence this hack.
        # TODO: Get to the bottom of why this is happening by removing the type setting and
        # running all cucumber specs to assess the errors.
        Letter::Draft.new(params.merge!(type: Letter::Draft.name, patient: patient))
      end

      def include_primary_care_physician_as_default_main_recipient
        return if letter.main_recipient.present?
        if patient.primary_care_physician.present?
          letter.build_main_recipient(person_role: :primary_care_physician)
        else
          letter.build_main_recipient(person_role: :patient)
        end
      end

      def contacts_with_default_cc_option
        patient.contacts.default_ccs
      end

      # Deal with wiring up new electronic CCs in the new, unsaved letter.
      # NB: The way electronic CCs are handled on building a new Letter and on updating an existing
      # one is different: when updating an existing letter (see code elsewhere) we lean on rails
      # doing some magic for us; as long as we have an array of electronic_cc_recipients in the
      # params, it will add/remove an associated electronic_receipt object for us (assigning the
      # letter_id to them in the process), because we used
      #   has_many :electronic_cc_recipients, through: :electronic_receipts
      # However, here, as we have no letter.id (letter is unsaved), Rails cannot yet create the
      # implied electronic_receipt object for each electronic_cc_recipient for us - we must do it
      # ourselves using electronic_receipts.build so rails will update the letter id in each when
      # the parent letter is saved.
      def build_electronic_ccs
        return if electronic_cc_recipient_ids.blank?
        electronic_cc_recipient_ids.reject(&:blank?).map do |user_id|
          letter.electronic_receipts.build(recipient_id: user_id)
        end
      end

      def build_salutation
        letter.salutation ||= begin
          main_recipient = letter.main_recipient
          if main_recipient.patient?
            patient.salutation
          elsif main_recipient.primary_care_physician?
            patient.primary_care_physician.salutation
          end
        end
      end

      def assign_default_ccs
        return if @default_ccs.empty?

        @default_ccs.each do |contact|
          letter.cc_recipients.build(person_role: "contact", addressee: contact)
        end
      end

      # def build_pathology_snapshot
      #   Pathology::BuildPathologySnapshot.new(
      #     patient: patient,
      #     descriptions: Letters::RelevantObservationDescription.all
      #   )#.to_h
      #   # descriptions = Letters::RelevantObservationDescription.all
      #   # query = Pathology::CurrentObservationsForDescriptionsQuery.new(
      #   #   patient: patient,
      #   #   descriptions: descriptions
      #   # )
      #   # transform_observations_into_snapshot(query.call)
      # end
    end
  end
end
