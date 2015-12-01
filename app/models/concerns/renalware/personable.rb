module Renalware
  module Personable
    extend ActiveSupport::Concern

    included do
      class_eval do
        validates_presence_of :given_name, :family_name
      end

      def full_name
        to_s(:full_name)
      end

      alias_method :orig_to_s, :to_s

      def to_s(format=nil)
        case format
        when :full_name
          "#{given_name} #{family_name}"
        when :reversed_full_name
          "#{family_name}, #{given_name}"
        when :reversed_full_name_with_nhs
          "#{family_name}, #{given_name} (#{nhs_number})"
        else
          orig_to_s
        end
      end
    end
  end
end