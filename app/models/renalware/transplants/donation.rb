require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class Donation < ActiveRecord::Base
      include PatientScope
      extend Enumerize

      belongs_to :patient

      has_paper_trail class_name: "Renalware::Transplants::Version"

      scope :ordered, -> (direction=:desc) { order(created_at: direction) }

      enumerize :state, in: %i(volunteered seen_in_clinic investigating handed_over unsuitable)
      enumerize :relationship_with_recipient, in: %i(
        son_or_daughter mother_or_father sibling_2_shared
        sibling_1_shared sibling_0_shared sibling
        monozygotic_twin dizygotic_twin other_living_related
        living_non_related_spouse living_non_related_partner
        pooled_paired altruistic_non_directed other_living_non_related
      )
      enumerize :blood_group_compatibility, in: %i(yes no)
      enumerize :paired_pooled_donation, in: %i(
        n_a information_given consented to_enroll_in_next_matching_un
      )

      validates :state, presence: true
      validates :relationship_with_recipient, presence: true
      validates :relationship_with_recipient_other, presence: true,
        if: "relationship_with_recipient.try(:other_living_non_related?)"
      validates :volunteered_on, timeliness: { type: :date, allow_blank: true }
      validates :first_seen_on, timeliness: { type: :date, allow_blank: true }
      validates :workup_completed_on, timeliness: { type: :date, allow_blank: true }
      validates :donated_on, timeliness: { type: :date, allow_blank: true }

      def self.policy_class
        BasePolicy
      end
    end
  end
end