module Renalware
  class Role < ActiveRecord::Base
    has_and_belongs_to_many :users

    validates_uniqueness_of :name

    def self.fetch(ids)
      return none if Array.wrap(ids).empty?

      find(ids)
    end
  end
end
