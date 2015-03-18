class ExitSiteInfection < ActiveRecord::Base
  
  has_many :medications, as: :treatable
  has_many :medication_routes, through: :medications
  has_many :patients, through: :medications, as: :treatable
  has_many :infection_organisms
  has_many :organism_codes, through: :infection_organisms, as: :infectable
 
  def self.medication_routes
    @medication_routes ||= YAML.load_file(Rails.root.join("data", "medication_routes.yml"))
  end

  def antibiotic_routes
    [].tap do |ary|
      (1..3).each do |num|
        ary << medication_route(send(:"antibiotic_#{num}_route"))
      end
    end
  end

  def medication_route(id)
    self.class.medication_routes.find { |r| r.id == id }
  end


end
