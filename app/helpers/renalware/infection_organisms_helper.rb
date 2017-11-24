module Renalware
  module InfectionOrganismsHelper
    def pd_infection_organisms_path(infectable)
      super(infectable_type: infectable.class.to_s, infectable_id: infectable.id)
    end

    def new_pd_infection_organism_path(infectable)
      super(infectable_type: infectable.class.to_s, infectable_id: infectable.id)
    end

    def organisms_and_sensitivities(infection_organisms)
      if infection_organisms.blank?
        "Unknown"
      else
        safe_join(
          infection_organisms.map do |io|
            "<li>#{io.organism_code.name} - #{io.sensitivity}</li>".html_safe
          end
        )
      end
    end

    def organisms(infection_organisms)
      if infection_organisms.blank?
        "Unknown"
      else
        safe_join(infection_organisms.map { |io| "<li>#{io.organism_code.name}</li>".html_safe })
      end
    end
  end
end
