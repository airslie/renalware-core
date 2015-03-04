require 'medication_route'

class PeritonitisEpisode < ActiveRecord::Base
  belongs_to :patient
  belongs_to :peritonitis_episode

  belongs_to :organism_1, :class_name => "OrganismCode", :foreign_key => :organism_1_id
  belongs_to :organism_2, :class_name => "OrganismCode", :foreign_key => :organism_2_id

  belongs_to :antibiotic_1, :class_name => "Antibiotic", :foreign_key => :antibiotic_1_id
  belongs_to :antibiotic_2, :class_name => "Antibiotic", :foreign_key => :antibiotic_2_id
  belongs_to :antibiotic_3, :class_name => "Antibiotic", :foreign_key => :antibiotic_3_id
  belongs_to :antibiotic_4, :class_name => "Antibiotic", :foreign_key => :antibiotic_4_id
  belongs_to :antibiotic_5, :class_name => "Antibiotic", :foreign_key => :antibiotic_5_id
 
  def self.medication_routes
    @medication_routes ||= YAML.load_file(Rails.root.join("data", "medication_routes.yml"))
  end

  def antibiotic_routes
    [].tap do |ary|
      (1..5).each do |num|
        ary << medication_route(send(:"antibiotic_#{num}_route"))
      end
    end
  end

  def medication_route(id)
    self.class.medication_routes.find { |r| r.id == id }
  end
 
end
