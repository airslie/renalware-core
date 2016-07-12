require_dependency "renalware/hd"

module Renalware
  module HD
    class ModalityDescription < ActiveRecord::Base
      belongs_to :description, class_name: "Modalities::Description"
      validates :description, presence: true

      def self.include?(record)
        exists?(description: record)
      end
    end
  end
end
