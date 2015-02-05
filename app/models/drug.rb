class Drug < ActiveRecord::Base
  include Concerns::SoftDelete
  include Concerns::Searchable

  index_name "drugs"

  document_type "drug"

  validates :name, presence: true

  scope :standard, -> { where("type is null or type = '' ") }

  def display_type
    "Standard Drug"
  end
  
  def as_indexed_json(options={})
    as_json(only: %i(name type))
  end
end
