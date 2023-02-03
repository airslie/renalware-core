# frozen_string_literal: true

module Renalware
  module Letters
    class ContactPresenter
      pattr_initialize :contact
      delegate_missing_to :contact
      delegate :to_s, to: :contact

      def description_name
        description.unspecified? ? other_description : description.to_s
      end

      def name_and_description
        "#{self} (#{description_name})"
      end
    end
  end
end
