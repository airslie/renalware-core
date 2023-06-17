CREATE
OR REPLACE FUNCTION renalware.insert_raw_hl7_message(message text) RETURNS void AS $$ BEGIN
/*
 This function supersedes `new_hl7_message`
 */
insert into
  renalware.feed_raw_hl7_messages(body)
values
  (message);

END;

$$ LANGUAGE plpgsql;
