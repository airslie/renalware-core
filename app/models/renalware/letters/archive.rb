require_dependency "renalware/letters"

module Renalware
  module Letters
    class Archive < ActiveRecord::Base
      include Accountable

      belongs_to :letter, class_name: "Renalware::Letters::Archived"

      validates_presence_of :content
    end
  end
end