require_dependency "renalware/letters"

module Renalware
  module Letters
    class Contact < ActiveRecord::Base
      belongs_to :patient
      belongs_to :person, class_name: "Directory::Person"

      delegate :address, :to_s, to: :person
    end
  end
end
