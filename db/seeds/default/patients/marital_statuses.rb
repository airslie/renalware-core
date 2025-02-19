module Renalware
  # See https://www.datadictionary.nhs.uk/data_elements/person_marital_status.html
  Rails.benchmark "Adding Martial Statuses" do
    statuses = [
      { code: :S, name: "Single" },
      { code: :M, name: "Married/Civil Partner" },
      { code: :D, name: "Divorced/Person whose Civil Partnership has been dissolved" },
      { code: :W, name: "Widowed/Surviving Civil Partner" },
      { code: :P, name: "Separated" },
      { code: :N, name: "Not disclosed" }
    ]
    Patients::MaritalStatus.upsert_all(statuses, unique_by: :code)
  end
end
