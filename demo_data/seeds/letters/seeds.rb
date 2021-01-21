# frozen_string_literal: true

require_relative "./letterheads"
require_relative "./letter_descriptions"
require_relative "./contact_descriptions"
require_relative "./contacts"
require_relative "./rabbit"

# Create dummy SQL view to demostrate mailshots
ActiveRecord::Base.connection.execute(<<-SQL)
  create or replace view renalware.letter_mailshot_patients_where_surname_starts_with_r
  as select id as patient_id from patients where family_name like 'R%';
SQL
