CREATE OR REPLACE FUNCTION renalware.new_hl7_message(message text) RETURNS void AS $$
BEGIN
/*
  This fn is called by the Mirth integration engine to add an HL7 message to Renalware.
  Mirth used to insert data directly into the delayed_jobs table but we are moving away from
  that approach as it tightly couples Mirth to our internal implementation and prevents us
  from easily moving to another background processing library eg que.

  When using delayed_jobs
  -----------------------
  1. We craft a yml string and translate line endings.
  2. The trigger function preprocess_hl7_message fires when a row is added to delayed_jobs.
     It handles escaping odd characters eg 10^12 in the message. See that function for details.
     Once we have migrated Mirth to use this function and are happy it is working we can
     move that logic from preprocess_hl7_message into here and drop that function and its trigger.

  When using que
  ------------------
  # TODO: psuedo SQL
*/
insert into renalware.delayed_jobs(handler, run_at, created_at, updated_at)
values(
  E'--- !ruby/struct:FeedJob\nraw_message: |\n  ' || REPLACE(message, E'\r', E'\n  '),
  NOW() AT TIME ZONE 'UTC',
  NOW() AT TIME ZONE 'UTC',
  NOW() AT TIME ZONE 'UTC'
);
END;
$$ LANGUAGE plpgsql;
