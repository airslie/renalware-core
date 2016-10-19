require_dependency "renalware/letters"

module Renalware
  module Letters
    class Contact < ActiveRecord::Base
      belongs_to :patient
      belongs_to :person, class_name: "Directory::Person"
      belongs_to :description, class_name: "ContactDescription"

      validates :person, presence: true, uniqueness: { scope: :patient }

      delegate :address, :to_s, to: :person
      delegate :name, to: :address, prefix: true

      scope :with_person, -> { includes(person: :address) }
      scope :ordered, -> {
        with_person.order("directory_people.family_name, directory_people.given_name")
      }

      scope :default_ccs, -> { where(default_cc: true) }

      def self.find_by_given_name(name)
        with_person.find_by(directory_people: { given_name: name })
      end

      def described_as?(description)
        (description == description) || (other_description == description)
      end
    end
  end
end
