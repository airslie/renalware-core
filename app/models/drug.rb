class Drug < ActiveRecord::Base
  include Concerns::SoftDelete

  validates :name, presence: true

  def display_type
    "Standard Drug"
  end
end
