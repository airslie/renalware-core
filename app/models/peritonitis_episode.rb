require 'medication_route'

class PeritonitisEpisode < ActiveRecord::Base
  belongs_to :patient

  def self.medication_routes
    @medication_routes ||= YAML.load_file(Rails.root.join("data", "medication_routes.yml"))
  end
 
end
