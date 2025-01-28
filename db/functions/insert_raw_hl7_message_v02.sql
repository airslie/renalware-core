CREATE OR REPLACE FUNCTION renalware.insert_raw_hl7_message(
  sent_at timestamp with time zone,
  message text
)
RETURNS void
AS $$
BEGIN
/*
 This function supersedes `new_hl7_message`
 */
insert into renalware.feed_raw_hl7_messages (sent_at, body) values(sent_at, message);

END;

$$ LANGUAGE plpgsql;
