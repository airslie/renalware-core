# frozen_string_literal: true

require_dependency "renalware/system"

module Renalware
  module System
    class Visit < ApplicationRecord
      # See https://github.com/ankane/ahoy
      has_many :events, class_name: "System::Event"
      belongs_to :user, optional: true
    end
  end
end
