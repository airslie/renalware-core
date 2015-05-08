class Drug < ActiveRecord::Base
  include Concerns::SoftDelete

  has_many :medications, as: :medicatable
  has_many :patients, through: :medications, as: :medicatable
  has_many :drug_drug_types
  has_many :drug_types, -> { uniq }, through: :drug_drug_types

  validates :name, presence: true

  scope :antibiotic, -> { joins(:drug_types).where(:drug_types => {:name => "Antibiotic"}) }
  scope :esa, -> { joins(:drug_types).where(:drug_types => {:name => "ESA"}) }
  scope :immunosuppressant, -> { joins(:drug_types).where(:drug_types => {:name => "Immunosuppressant"}) }
  scope :peritonitis, -> { joins(:drug_types).where(:drug_types => {:name => "Peritonitis"}) }

  def display_type
    "Standard Drug"
  end

  def self.ransackable_scopes(auth=nil)
    %i(active)
  end

  # A JSON representation compatible with select2.
  #
  def as_json(options={})
    { id: self.id, text: self.name }
  end
end
