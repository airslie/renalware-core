require_dependency "renalware/letters"

module Renalware
  module Letters
    class Letter < ApplicationRecord
      include Accountable
      extend Enumerize
      # The letterhead is the only site-specific element in the letter, so we use this
      # to determine site-specific settings - in this case whether the letter should contain
      # pathology. At KCH for example, Darren Valley letters should not contain recent pathology.
      delegate :include_pathology_in_letter_body?, to: :letterhead, allow_nil: true

      belongs_to :event, polymorphic: true
      belongs_to :author
      belongs_to :patient, touch: true
      belongs_to :letterhead
      has_one :main_recipient,
              -> { where(role: "main") },
              class_name: "Recipient",
              inverse_of: :letter
      has_many :cc_recipients,
               -> { where(role: "cc") },
               class_name: "Recipient",
               dependent: :destroy,
               inverse_of: :letter
      has_many :recipients, dependent: :destroy
      has_many :electronic_receipts, dependent: :destroy
      has_many :electronic_cc_recipients,
               through: :electronic_receipts,
               source: :recipient
      has_one :signature, dependent: :destroy
      has_one :archive, foreign_key: "letter_id", inverse_of: :letter
      serialize :pathology_snapshot, Pathology::ObservationsJsonbSerializer

      accepts_nested_attributes_for :main_recipient
      accepts_nested_attributes_for :cc_recipients, reject_if: :all_blank, allow_destroy: true

      validates :letterhead, presence: true
      validates :author, presence: true
      validates :patient, presence: true
      validates :issued_on, presence: true
      validates :description, presence: true
      validates :main_recipient, presence: true

      include ExplicitStateModel
      has_states :draft, :pending_review, :approved, :completed
      state_scope :reviewable, :pending_review

      scope :pending, lambda {
        where(type: [state_class_name(:draft), state_class_name(:pending_review)])
      }
      singleton_class.send(:alias_method, :in_progress, :pending)

      scope :reverse, -> { order(updated_at: :desc) }
      scope :with_letterhead, -> { includes(:letterhead) }
      scope :with_main_recipient, -> { includes(main_recipient: [:address, :addressee]) }
      scope :with_author, -> { includes(:author) }
      scope :with_patient, -> { includes(patient: :primary_care_physician) }
      scope :with_event, -> { includes(:event) }
      scope :with_cc_recipients, -> { includes(cc_recipients: { addressee: { person: :address } }) }

      delegate :primary_care_physician, to: :patient

      def self.policy_class
        LetterPolicy
      end

      def self.for_event(event)
        where(event: event).first
      end

      EVENTS_MAP = {
        Clinics::ClinicVisit => Event::ClinicVisit,
        NilClass => Event::Unknown
      }.freeze

      # A Letter Event is unrelated to Events::Event. Instead it is an un-persisted decorator
      # around the polymorphic event relationship (determined by event_class and event_id);
      # each concrete Event class decorates that relationship with some helpers, for example
      # #part_classes which determined which extra letter 'parts' should be rendered for that
      # specific polymorphic relationship. Note that general clinical parts_classes are defined
      # on Letter, because a relationship to say a ClinicVisit (the letter event) is not required
      # for a letter to want to have clinical content (prescriptions etc.). Clinical parts will
      # always be included if #clinical? is true. This for example enables us to create a
      # 'clinical letter' which is a simple letter with the added clinical parts, but which is
      # unrelated to a clinic_visit for instance.
      def letter_event
        EVENTS_MAP.fetch(event.class).new(event, clinical: clinical?)
      end

      def subject?(other_patient)
        patient == other_patient
      end

      def find_cc_recipient_for_contact(contact)
        cc_recipients.detect { |recipient| recipient.for_contact?(contact) }
      end

      def determine_counterpart_ccs
        DetermineCounterpartCCs.new(self).call
      end

      def signed?
        signature.present?
      end

      def archived?
        archive.present?
      end

      def archived_by
        archive.created_by
      end

      def archive_recipients!
        recipients.each(&:archive!)
      end
    end
  end
end
