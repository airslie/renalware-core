class ExitSiteInfection < ActiveRecord::Base
  belongs_to :patient

  belongs_to :organism_1, :class_name => "OrganismCode", :foreign_key => :organism_1_id
  belongs_to :organism_2, :class_name => "OrganismCode", :foreign_key => :organism_2_id

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
