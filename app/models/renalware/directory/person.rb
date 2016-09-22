require_dependency "renalware/directory"

module Renalware
  module Directory
    class Person < ActiveRecord::Base
      include Personable
      include Accountable

      has_one :address, as: :addressable

      accepts_nested_attributes_for :address

      scope :ordered, -> { order(:family_name, :given_name) }
      scope :with_address, -> { includes(:address) }

      def self.policy_class
        BasePolicy
      end

      def self.build(attributes = {})
        person = self.new(attributes)
        person.build_address
        person
      end
    end
  end
end
