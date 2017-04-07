module PathologySpecHelper
  def create_descriptions(names)
    names.map { |name| create_observation_description(name) }
  end

  def create_observations(patient,
                          descriptions,
                          observed_at: Time.zone.now,
                          result: 1)
    descriptions.map do |description|
      request = create(:pathology_observation_request, patient: patient)
      create(:pathology_observation,
             request: request,
             description: description,
             observed_at: observed_at,
             result: result)
    end
  end

  # name and code will be the same
  def create_observation_description(name)
    create(:pathology_observation_description, name: name, code: name)
  end

  def create_patient
    patient = create(:patient)
    Renalware::Pathology.cast_patient(patient)
  end

  def add_descriptions_not_observed_for_patient(*description_names)
    description_names.map { |name| create_observation_description(name) }
  end

  def filter_targeted_descriptions(descriptions)
    descriptions.select { |description| description.name.start_with?("target-") }
  end
end
