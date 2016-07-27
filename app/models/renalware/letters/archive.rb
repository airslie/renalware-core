require_dependency "renalware/letters"

module Renalware
  module Letters
    class Archive < ActiveRecord::Base
      belongs_to :letter, class_name: "Renalware::Letters::Archived"
      belongs_to :created_by, class_name: "Renalware::User"

      validates_presence_of :created_by, :content
    end
  end
end