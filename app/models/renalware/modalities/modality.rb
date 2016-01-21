require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class Modality < ActiveRecord::Base

      acts_as_paranoid

      belongs_to :description, class_name: "Description"
      belongs_to :patient
      belongs_to :reason, class_name: "Reason"

      scope :ordered, -> { order(ended_on: :desc, updated_at: :desc) }

      scope :started_on_reversed, -> { order(started_on: :desc, updated_at: :desc) }
      scope :last_started_on, -> { started_on_reversed.with_deleted.where(ended_on: nil) }

      validates :patient, presence: true
      validates :started_on, presence: true
      validates :description, presence: true

      validates :started_on, timeliness: { type: :date }

      validate :validate_modality_starts_later_than_previous, on: :create, if: :patient

      def transfer!(attrs)
        transaction do
          successor = patient.modalities.create(attrs)
          terminate!(successor) if successor.valid?

          successor
        end
      end

      def to_s
        description.name
      end

      private

      def validate_modality_starts_later_than_previous
        unless started_later_than_previous?
          errors.add(:started_on, "can't be before previous modality's start date.")
        end
      end

      def started_later_than_previous?
        if previous_modality = patient.modalities.last_started_on.first
          started_on.present? && started_on >= previous_modality.started_on
        else
          true
        end
      end

      def terminate!(successor)
        self.ended_on = successor.started_on
        save!
        destroy!
      end
    end
  end
end
