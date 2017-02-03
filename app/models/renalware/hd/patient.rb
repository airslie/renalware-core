require_dependency "renalware/hd"

module Renalware
  module HD
    class Patient < ActiveType::Record[Renalware::Patient]
      has_one :hd_profile, class_name: "Profile"
      has_many :hd_sessions, class_name: "Session"
      scope :with_profile, -> { includes(:hd_profile) }

      def treated?
        modality_descriptions.exists?(type: "Renalware::HD::ModalityDescription")
      end
    end
  end
end
