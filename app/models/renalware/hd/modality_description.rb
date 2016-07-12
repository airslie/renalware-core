require_dependency "renalware/hd"

module Renalware
  module HD
    class ModalityDescription < ActiveRecord::Base
      belongs_to :description, class_name: "Modalities::Description"
      validates :description, presence: true

      def self.include?(record)
        pluck(:description_id).include?(record.id)
      end
    end
  end
end
