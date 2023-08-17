# frozen_string_literal: true

module Renalware
  module Modalities
    class Description < ApplicationRecord
      acts_as_paranoid

      validates :name, presence: true, uniqueness: true

      scope :ignorable_for_aki_alerts, -> { where(ignore_for_aki_alerts: true) }
      scope :ignorable_for_kfre, -> { where(ignore_for_kfre: true) }

      def to_s = name

      def to_sym
        nil
      end

      def self.policy_class = DescriptionPolicy

      # Modalities::Description subclasses can override this to for instance add
      # the patient's 'HD Site' add after 'HD'
      def augmented_name_for(_patient)
        name
      end

      # For a ModalityDescription with type Renalware::HD::ModalityDescription
      # this will return "hd"
      def namespace
        return if type.blank?

        namespace_raw.underscore
      end

      # For a ModalityDescription with type Renalware::HD::ModalityDescription
      # this will return "HD"
      def namespace_raw
        return if type.blank?

        type.gsub("::", "").gsub(/^Renalware/, "").gsub(/ModalityDescription$/, "")
      end
    end
  end
end
