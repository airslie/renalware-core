/* Create a function for the trigger to call */
CREATE OR REPLACE FUNCTION preprocess_hl7_message() RETURNS trigger AS
$body$
BEGIN
  /*
  Mirth inserts a row into delayed job when a new HL7 message needs to be processed by Renalware.
  The SQL it uses looks like this:
    insert into renalware.delayed_jobs (handler, run_at)
    values(E'--- !ruby/struct:FeedJob\nraw_message: |\n  ' || REPLACE(${message.rawData},E'\r',E'\n  '), NOW());
  This works unless there is a 10^12 value in the unit of measurement segment for an OBX (e.g.
  for WBC or HGB). Then Mirth encodes the ^ as \S\ because ^ is a significant character in Mirth
  (field separator). Unfortunately this creates the combination
  10\S\12 and S\12 is converted to \n when the handler's payload is loaded in by the delayed_job worker.
  To get around this we need to convert instances of \S\ with another escape sequence eg «
  and manually map this back to a ^ in the job handler ruby code.

  So here, if this delayed_job is destined to be picked up by a Feed job handler
  make sure we convert the Mirth escape sequence \S\ to \\S\\
  */
  IF position('Feed' in NEW.handler) > 0 THEN
    NEW.handler = replace(NEW.handler, E'\\S\\', E'\\\\S\\\\');
    NEW.created_at = now();
    NEW.updated_at = now();
  END IF;

  RETURN NEW;
END

$body$
LANGUAGE plpgsql;

