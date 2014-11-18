class Drug < ActiveRecord::Base
  include Concerns::SoftDelete

  validates :name, presence: true

  scope :standard, -> { where("type is null or type = '' ") }

  def display_type
    "Standard Drug"
  end
end
