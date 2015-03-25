class Drug < ActiveRecord::Base
  include Concerns::SoftDelete
  include Concerns::Searchable

  has_many :medications, as: :medicatable
  has_many :patients, through: :medications, as: :medicatable
  has_many :drug_drug_types
  has_many :drug_types, -> { uniq }, through: :drug_drug_types

  #Indexing for drug search 
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
