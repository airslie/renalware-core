class LetterDescription < ActiveRecord::Base
  validates_presence_of :text

  has_many :letters
end
