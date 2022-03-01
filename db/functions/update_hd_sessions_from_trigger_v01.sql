set SEARCH_PATH=renalware,public;

CREATE OR REPLACE FUNCTION update_hd_sessions_from_trigger() RETURNS TRIGGER AS $body$
DECLARE
begin
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') then
    NEW.performed_on = NEW.started_at::date;
  END IF;
  RETURN NEW ;
END $body$ LANGUAGE plpgsql VOLATILE COST 100;

COMMENT ON FUNCTION update_hd_sessions_from_trigger() IS
'For backward-compatibility with any SQL written to query hd_sessions.performed_on,
when the replacement started_at column is changed, write the data part
to the legacy performed_on column';
