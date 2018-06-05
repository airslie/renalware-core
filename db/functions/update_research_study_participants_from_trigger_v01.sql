set SEARCH_PATH=renalware,public;
CREATE OR REPLACE FUNCTION renalware.update_research_study_participants_from_trigger() RETURNS TRIGGER AS $body$
/*
TC 05/06/2018
After a participant is added to a study, assign them an external_id, to be used when sending this
data for example to an external study application.
We use pseudo_encrypt() to generate a random id which is guaranteed to be unique as it is based
on the id. Its not the most secure however as, without a secret, the id can be reverse engineered
if our pseudo_encrypt sql function open source (which it is). If this is deemed to be a problem
(our intention at this point is rudimentary obfuscation), a hospital can override replace this
function with a more secure one.
An alternative to using a trigger is to use an after_ or before_save hook in Rails. The trigger
approach is chosen as, unlike a traditional Rails app, some direct data manipulation can be expected
in Renalware, even if that is just during migration.
*/
BEGIN
  IF (TG_OP = 'INSERT') THEN
    NEW.external_id = renalware.pseudo_encrypt(NEW.id::integer);
    RETURN NEW;
  END IF;
  RETURN NULL;
END $body$ LANGUAGE plpgsql VOLATILE COST 100;
