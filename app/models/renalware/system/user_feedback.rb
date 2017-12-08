require_dependency "renalware/system"

module Renalware
  module System
    class UserFeedback < ApplicationRecord
      extend Enumerize
      validates :author, presence: true
      validates :category, presence: true
      validates :comment, presence: true

      belongs_to :author, class_name: "User"

      enumerize :category, in: %i(general bug missing_feature), default: :general
    end
  end
end
