class CreateTransplantUKTDeathCauses < ActiveRecord::Migration[7.1]
  DEATH_CAUSES = {
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
  }.freeze

  def change
    within_renalware_schema do
      create_table :transplant_ukt_death_causes do |t|
        t.string :code, null: false, index: { unique: true }
        t.string :name, null: false, index: { unique: true }
        t.integer :position, null: false
        t.boolean :enabled, null: false, default: true
        t.timestamps null: false
      end

      reversible do |dir|
        dir.up { insert_death_causes }
      end
    end
  end

  private

  def insert_death_causes
    safety_assured do
      DEATH_CAUSES.each.with_index(1) do |(code, name), position|
        execute <<~SQL.squish
          INSERT INTO transplant_ukt_death_causes (code, name, position, created_at, updated_at)
          VALUES (#{connection.quote(code)}, #{connection.quote(name)}, #{position},
                  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
        SQL
      end
    end
  end
end
