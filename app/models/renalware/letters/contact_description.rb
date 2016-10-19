require_dependency "renalware/letters"

module Renalware
  module Letters
    class ContactDescription < ActiveRecord::Base
      validates :system_code, presence: true, uniqueness: true
      validates :name, presence: true, uniqueness: true
      validates :position, presence: true, uniqueness: true

      scope :ordered, -> { order(:position) }
      scope :specified, -> { not.where(system_code: UNSPECIFIED_SYSTEM_CODE) }

      UNSPECIFIED_SYSTEM_CODE = "other"

      def self.[](system_code)
        find_by!(system_code: system_code.to_s)
      end

      def unspecified?
        system_code == UNSPECIFIED_SYSTEM_CODE
      end

      def to_s
        name
      end
    end
  end
end
