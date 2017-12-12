# The pathology_current_observation_sets table has a values hash (jsonb)
# of the most recent pathology.
#
# You can refresh the content of this table with the following query:
#
#   with current_patient_obs as(
#     select
#       DISTINCT ON (p.id, obxd.id)
#       p.id as patient_id,
#       obxd.code,
#       json_build_object('result',(obx.result),'observed_at',obx.observed_at) as value
#       from patients p
#       inner join pathology_observation_requests obr on obr.patient_id = p.id
#       inner join pathology_observations obx on obx.request_id = obr.id
#       inner join pathology_observation_descriptions obxd on obx.description_id = obxd.id
#       order by p.id, obxd.id, obx.observed_at desc
#   ),
#   current_patient_obs_as_jsonb as (
#     select patient_id,
#       jsonb_object_agg(code, value) as values,
#       CURRENT_TIMESTAMP,
#       CuRRENT_TIMESTAMP
#       from current_patient_obs
#       group by patient_id order by patient_Id
#   )
#   insert into pathology_current_observation_sets (patient_id, values, created_at, updated_at)
#     select * from current_patient_obs_as_jsonb
#     ON conflict (patient_id)
#     DO UPDATE
#     SET values = excluded.values, updated_at = excluded.updated_at;

class CreatePathologyCurrentTable < ActiveRecord::Migration[5.1]
  def change
    create_table :pathology_current_observation_sets do |t|
      t.references :patient, null: false, foreign_key: true, index: { unique: true }
      t.jsonb :values, index: { using: :gin }, default: {}

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end

    drop_view :pathology_current_key_observation_sets, revert_to_version: 2
    # drop_view :pathology_current_observations, revert_to_version: 1
  end
end

# WIP trigger to update update_current_observation_set when an obs is inserted.
# I gave up on the formattin() the path to search eg {'HGB'}.
# Should work fine once that prob solved.
#
# --drop function update_current_observation_set_from_trigger();
# SET SEARCH_PATH = renalware,
#  PUBLIC;

# CREATE
# OR REPLACE FUNCTION update_current_observation_set_from_trigger() RETURNS TRIGGER AS $body$
# DECLARE
#     _patient_id bigint;
#     _code text;
# BEGIN
#   RAISE NOTICE 'TRIGGER called on %',TG_TABLE_NAME ;

#   IF (TG_OP = 'INSERT') THEN
#     RAISE NOTICE 'Request %', NEW.request_id;
#     select
#       request.patient_id into _patient_id
#       from pathology_observation_requests request
#       where request.id = NEW.request_id;
#     select description.code into _code
#       from pathology_observation_descriptions description
#       where description.id = NEW.description_id;

#     RAISE NOTICE 'patient_id %', _patient_id;
#     RAISE NOTICE 'code %', _code;

#     insert into pathology_current_observation_sets (patient_id) values (_patient_id)
#     ON CONFLICT DO NOTHING;

#     execute format('
#     update pathology_current_observation_sets
#       set values= jsonb_set(values, '''', "Mary", true)
#     where patient_id = %', _code, _patient_id);

#   END IF;
#   RETURN NULL ;
# END $body$ LANGUAGE plpgsql VOLATILE COST 100;

# DROP TRIGGER
# IF EXISTS add_log_current_trigger ON pathology_observations;

# CREATE TRIGGER add_log_current_trigger AFTER INSERT
# OR UPDATE ON pathology_observations FOR EACH ROW EXECUTE PROCEDURE update_current_observation_set_from_trigger();

# UPDATE pathology_observations
# SET observed_at = CURRENT_TIMESTAMP
# WHERE
#   RESULT = '3';

# SELECT COUNT(*) FROM pathology_observations;

# 9. Update or insert an attribute
# Use the || operator to concatenate the actual data with the new data. It will update or insert the value.
# UPDATE users SET metadata = metadata || '{"country": "Egypt"}';


