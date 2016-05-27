require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Lab < ActiveRecord::Base
      has_many :request_descriptions, class_name: "RequestDescription"

      validates :name, presence: true
    end
  end
end
