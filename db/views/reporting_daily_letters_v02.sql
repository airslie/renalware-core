select
  (select count(*) from letter_letters where created_at::date = now()::date) as letters_created_today,
  (select count(*) from letter_letters where completed_at::date = now()::date) as letters_printed_today,
  (select count(*) from letter_letters where type = 'Renalware::Letters::Letter::Draft' and issued_on < (current_date - interval '14 days')) as draft_letters_older_than_14_days;
