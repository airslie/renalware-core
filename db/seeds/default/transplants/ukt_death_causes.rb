require_relative "../../seeds_helper"

module Renalware
  module Transplants
    Rails.benchmark "Adding UKT death causes" do
      {
        acute_blood_loss: "Acute blood loss/hypovolaemia",
        alcohol_poisoning: "Alcohol poisoning",
        aneurysm: "Aneurysm",
        asthma: "Asthma",
        brain_tumour: "Brain tumour",
        cancer: "Cancer (other than brain tumour)",
        carbon_monoxide_poisoning: "Carbon monoxide poisoning",
        cardiac_arret: "Cardiac arrest",
        cardiovascular_unclassified: "Cardiovascular - type unclassified",
        chronic_pulmonary_disease: "Chronic pulmonary disease",
        congestive_heart_failure: "Congestive heart failure",
        hypoxic_brain_damage: "Hypoxic brain damage - all causes",
        infections_unclassified: "Infections - type unclassified",
        intracranial_haemorrhage: "Intracranial haemorrhage",
        intracranial_thrombosis: "Intracranial thrombosis",
        intracranial_unclassidied: "Intracranial - type unclassified (CVA)",
        ischaemic_heart_disease: "Ischaemic heart disease",
        liver_failure: "Liver failure (not self-poisoning)",
        meningitis: "Meningitis",
        multi_organ_failure: "Multi-organ failure",
        myocardial_infarction: "Myocardial infarction",
        other: "Other, please specify",
        other_drug_overdose: "Other drug overdose, please specify",
        other_trauma_accident: "Other trauma - accident",
        other_trauma_suicide: "Other trauma - known or suspected suicide",
        other_trauma_unknown: "Other trauma - unknown cause",
        paracetamol_overdose: "Paracetamol overdose",
        pneumonia: "Pneumonia",
        pulmonary_embolism: "Pulmonary embolism",
        renal_failure: "Renal failure",
        respiratory_failure: "Respiratory failure",
        respiratory_unclassified: "Respiratory - type unclassified (inc smoke inhalation)",
        self_poisoning_unclassified: "Self-poisoning - type unclassified",
        septicaemia: "Septicaemia",
        sudden_infant_death_syndrome: "Sudden Infant Death Syndrome (SIDS)",
        trauma_rta_car: "Trauma RTA - car",
        trauma_rta_motorbike: "Trauma RTA - motorbike",
        trauma_rta_pedestrian: "Trauma RTA - pedestrian",
        trauma_rta_pushbike: "Trauma RTA - pushbike",
        trauma_rta_unknown: "Trauma RTA - unknown type",
        unknown: "Unknown"
      }.each.with_index(1) do |(code, name), position|
        UKTDeathCause.find_or_create_by!(code:) do |cause|
          cause.name = name
          cause.position = position
        end
      end
    end
  end
end
