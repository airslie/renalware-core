class CreateTriggerToPreprocessHL7Msg < ActiveRecord::Migration[5.1]
  def up
    sql = <<-SQL
      /* Create a function for the trigger to call */
      CREATE FUNCTION preprocess_hl7_message() RETURNS trigger AS
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

        So here, if this delayed_job is destinated to be picked up by a Feed job handler
        make sure we convert the Mirth escape sequence \S\ to «
        */
        IF position('Feed' in NEW.handler) > 0 THEN
          NEW.handler = replace(NEW.handler, '\S\', '«');
        END IF;

        RETURN NEW;
      END

      $body$
      LANGUAGE plpgsql;

      /* Create the trigger! */
      CREATE TRIGGER feed_messages_preprocessing_trigger
        BEFORE INSERT
        ON delayed_jobs
        FOR EACH ROW
        EXECUTE PROCEDURE preprocess_hl7_message();
    SQL

    connection.execute(sql)
  end

  def down
    connection.execute("
      drop trigger if exists feed_messages_preprocessing_trigger on delayed_jobs;
      drop function if exists preprocess_hl7_message1();
      drop function if exists preprocess_hl7_message();"
    )
  end
end
