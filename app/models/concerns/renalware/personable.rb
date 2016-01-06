module Renalware
  module Personable
    extend ActiveSupport::Concern

    included do
      class_eval do
        validates_presence_of :given_name, :family_name
      end

      def full_name
        "#{given_name} #{family_name}"
      end

      def to_s(format=:default)
        case format
        when :default
          "#{family_name}, #{given_name}"
        when :long
          "#{family_name}, #{given_name} (#{nhs_number})"
        end
      end
    end
  end
end