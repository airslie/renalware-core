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

      t.timestamps null: false
    end
  end
end


