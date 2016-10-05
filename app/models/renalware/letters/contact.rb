require_dependency "renalware/letters"

module Renalware
  module Letters
    class Contact < ActiveRecord::Base
      belongs_to :patient
      belongs_to :person, class_name: "Directory::Person"

      delegate :address, :to_s, to: :person
      delegate :name, to: :address, prefix: true

      scope :with_person, -> { includes(:person) }
    end
  end
end
