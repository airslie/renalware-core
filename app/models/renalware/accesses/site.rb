module Renalware
  module Accesses
    class Site < ActiveRecord::Base
      validates :code, presence: true
      validates :name, presence: true

      scope :ordered, -> () { order(:name) }
    end
  end
end
