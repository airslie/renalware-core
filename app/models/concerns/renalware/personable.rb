module Renalware
  module Personable
    extend ActiveSupport::Concern

    included do
      class_eval do
        validates :given_name, presence: true
        validates :family_name, presence: true
      end

      def full_name
        "#{given_name} #{family_name}"
      end

      def to_s(format = :default)
        case format
        when :default
          "#{family_name}, #{given_name}"
        when :long
          "#{family_name}, #{given_name} (#{nhs_number})"
        end
      end

      def salutation
        parts = [Renalware.config.salutation_prefix]
        parts << (title.presence || given_name)
        parts << family_name
        parts.compact.join(" ")
      end
    end
  end
end
