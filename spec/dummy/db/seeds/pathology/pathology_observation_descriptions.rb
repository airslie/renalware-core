# frozen_string_literal: true

module Renalware
  log "Adding Pathology Observation Descriptions" do

    file_path = File.join(File.dirname(__FILE__), "pathology_observation_descriptions.csv")

    CSV.foreach(file_path, headers: true) do |row|
      measurement_unit_name = row["unit_of_measurement"]
      measurement_unit_id = if measurement_unit_name.present?
                              Pathology::MeasurementUnit.find_by(name: measurement_unit_name).id
                            else
                              nil
                            end
      Pathology::ObservationDescription.find_or_create_by!(
        code: row["code"],
        name: row["name"],
        measurement_unit_id: measurement_unit_id,
        loinc_code: row["loinc_code"],
        display_group: row["display_group"],
        display_order: row["display_order"],
        letter_group: row["letter_group"],
        letter_order: row["letter_order"]
      )
    end

    sql = <<-SQL
      -- Display group and order determine path display on e.g. Current Pathology
      UPDATE renalware.pathology_observation_descriptions set display_group = NULL, display_order = NULL;
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=1 where code = 'HGB';
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=2 where code = 'MCV';
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=3 where code = 'MCH';
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=4 where code = 'HYPO';
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=5 where code = 'WBC';
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=6 where code = 'LYM';
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=7 where code = 'NEUT';
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=8 where code = 'PLT';
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=9 where code = 'RETA';
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=1  where code = 'ESR';
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=1  where code = 'CRP';
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=1  where code = 'FER';
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=1  where code = 'FOL';
      UPDATE renalware.pathology_observation_descriptions set display_group=1, display_order=1  where code = 'B12';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=1 where code = 'URE';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=2 where code = 'CRE';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=3 where code = 'EGFR';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=4 where code = 'NA';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=5 where code = 'POT';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=6 where code = 'BIC';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=7 where code = 'CCA';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=8 where code = 'PHOS';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=9 where code = 'PTHI';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=1  where code = 'TP';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=1  where code = 'GLO';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=1  where code = 'ALB';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=1  where code = 'URAT';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=14 where code = 'ACR';
      UPDATE renalware.pathology_observation_descriptions set display_group=2, display_order=15 where code = 'PCR';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=1 where code = 'BIL';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=2 where code = 'ALT';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=3 where code = 'AST';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=4 where code = 'ALP';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=5 where code = 'GGT';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=6 where code = 'BGLU';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=7 where code = 'HBA';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=8 where code = 'HBAI';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=9 where code = 'CHOL';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=10  where code = 'HDL';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=11  where code = 'LDL';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=12  where code = 'TRIG';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=13  where code = 'TSH';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=14  where code = 'CK';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=15  where code = 'URR';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=16  where code = 'CRCL';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=17  where code = 'UREP';
      UPDATE renalware.pathology_observation_descriptions set display_group=3, display_order=18  where code = 'AL';

      -- Letters pathology - the significance of the group here is that each will get its own date output
      -- in the letter. letter_order determines the order in the group
      UPDATE renalware.pathology_observation_descriptions set letter_group = NULL, letter_order = NULL;
      UPDATE renalware.pathology_observation_descriptions set letter_group=1, letter_order=1 where code = 'HGB';
      UPDATE renalware.pathology_observation_descriptions set letter_group=1, letter_order=2 where code = 'WBC';
      UPDATE renalware.pathology_observation_descriptions set letter_group=1, letter_order=3 where code = 'PLT';
      UPDATE renalware.pathology_observation_descriptions set letter_group=2, letter_order=1 where code = 'URE';
      UPDATE renalware.pathology_observation_descriptions set letter_group=3, letter_order=1 where code = 'CRE';
      UPDATE renalware.pathology_observation_descriptions set letter_group=3, letter_order=2 where code = 'EGFR';
      UPDATE renalware.pathology_observation_descriptions set letter_group=4, letter_order=1 where code = 'NA';
      UPDATE renalware.pathology_observation_descriptions set letter_group=4, letter_order=2 where code = 'POT';
      UPDATE renalware.pathology_observation_descriptions set letter_group=5, letter_order=1 where code = 'BIC';
      UPDATE renalware.pathology_observation_descriptions set letter_group=6, letter_order=1 where code = 'CCA';
      UPDATE renalware.pathology_observation_descriptions set letter_group=6, letter_order=2 where code = 'PHOS';
      UPDATE renalware.pathology_observation_descriptions set letter_group=7, letter_order=1 where code = 'PTHI';
      UPDATE renalware.pathology_observation_descriptions set letter_group=8, letter_order=1  where code = 'ALB';
      UPDATE renalware.pathology_observation_descriptions set letter_group=9, letter_order=1 where code = 'BIL';
      UPDATE renalware.pathology_observation_descriptions set letter_group=9, letter_order=2 where code = 'AST';
      UPDATE renalware.pathology_observation_descriptions set letter_group=9, letter_order=3 where code = 'ALP';
      UPDATE renalware.pathology_observation_descriptions set letter_group=9, letter_order=4 where code = 'GGT';
      UPDATE renalware.pathology_observation_descriptions set letter_group=10, letter_order=1 where code = 'HBA';
      UPDATE renalware.pathology_observation_descriptions set letter_group=11, letter_order=1 where code = 'CHOL';

    SQL
    ActiveRecord::Base.connection.execute(sql)
  end
end
