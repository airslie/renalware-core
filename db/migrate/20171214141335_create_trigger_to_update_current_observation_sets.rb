class CreateTriggerToUpdateCurrentObservationSets < ActiveRecord::Migration[5.1]
  def up
    sql = <<-SQL
      CREATE OR REPLACE FUNCTION update_current_observation_set_from_trigger() RETURNS TRIGGER AS $body$
        -- TC 14/12/2017
        -- This function is called by a trigger when a row is inserted or updated in
        -- pathology_observations. Its purpose is to keep current_observation_sets up to date
        -- with the latest observations for any patient.
        -- The current_observation_sets table maintains a jsonb hash into which we insert or replace
        -- the observation, keyed by OBX code.
        -- e.g.  .. {"HGB": { "result": 123.1, "observed_at": '2017-12-12-01:01:01'}, ..
        DECLARE
          a_patient_id bigint;
          a_code text;
          current_observed_at timestamp;
          current_result text;
          new_observed_at timestamp;
        BEGIN
          RAISE NOTICE 'TRIGGER called on %',TG_TABLE_NAME ;

          /*
          If inserting or updating, we _could_ assume the last observation to be inserted is
          the most 'recent' one (with the latest observed_at date).
          However the order of incoming messages is not guaranteed, so we have two options:
          1. Refresh the entire current_observation_set for the patient
          2. Check the current observed_at date in the jsonb and only update if we have a more
             recent one
          We have gone for 2.
          */

          IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN

            -- Note we could re-generate the entire current pathology for the patient using
            --  select refresh_current_observation_set(a_patient_id);
            -- which is safer but uses more resources, so avoiding this for now.

            -- Find and store patient_id into local variable
            select request.patient_id into a_patient_id
              from pathology_observation_requests request
              where request.id = NEW.request_id;

            -- Find and store the obx code into local variable
            select description.code into a_code
              from pathology_observation_descriptions description
              where description.id = NEW.description_id;

            -- Important! Create the observation_set if it doesn exist yet
            -- ignore the error id the row already exists
            insert into pathology_current_observation_sets (patient_id)
            values (a_patient_id)
            ON CONFLICT DO NOTHING;

            -- We are going to compare the current and new observed_at dates
            -- so need to cast them  to a timestamp
            select cast(New.observed_at as timestamp) into new_observed_at;

            -- Get the most recent date and value for this observation
            -- and store to variables.
            select
            cast(values -> a_code ->> 'observed_at' as timestamp),
            values -> a_code ->> 'result'
            into current_observed_at, current_result from
            pathology_current_observation_sets
            where patient_id = a_patient_id;

            -- Output some info to helps us debug. This can be removed later.
            RAISE NOTICE '  Request id % Patient id % Code %', NEW.request_id, a_patient_id, a_code;
            RAISE NOTICE '  Last %: % at %', a_code, current_result, current_observed_at;
            RAISE NOTICE '  New  %: % at %', a_code, NEW.result, new_observed_at;

            IF current_observed_at IS NULL OR new_observed_at >= current_observed_at THEN
              -- The new pathology_observation row contain a more recent result that the old one.
              -- (note there may not be an old one if the patient has neve had this obs before).

              RAISE NOTICE '  Updating pathology_current_observation_sets..';

              -- Update the values jsonb column with the new hash for this code, e.g.
              -- .. {"HGB": { "result": 123.1, "observed_at": '2017-12-12-01:01:01'}, ..
                    -- Note the `set values` below actually reads in the jsonb, updates it,
                    -- and wites the whole thing back.
              update pathology_current_observation_sets
                set values = jsonb_set(
                  values,
                  ('{'||a_code||'}')::text[], -- defined in the fn path::text[]
                  jsonb_build_object('result', NEW.result, 'observed_at', new_observed_at),
                  true)
                where patient_id = a_patient_id;
            END IF;
          END IF;
          RETURN NULL ;
        END $body$ LANGUAGE plpgsql VOLATILE COST 100;
      -- End function

      -- Create the trigger which will call out function every time a row in pathology_observations
      -- is inserted or updated
      DROP TRIGGER IF EXISTS update_current_observation_set_trigger ON pathology_observations;
      CREATE TRIGGER update_current_observation_set_trigger
        AFTER INSERT OR UPDATE
        ON pathology_observations
        FOR EACH ROW EXECUTE PROCEDURE update_current_observation_set_from_trigger();
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    ActiveRecord::Base.connection.execute("
      DROP TRIGGER IF EXISTS update_current_observation_set_trigger ON pathology_observations;
      DROP FUNCTION IF EXISTS update_current_observation_set_from_trigger();
    ")
  end
end
