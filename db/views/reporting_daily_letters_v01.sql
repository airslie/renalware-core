select
  (select count(*) from letter_letters where created_at::date = now()::date) as letters_created_today,
  (select count(*) from letter_letters where completed_at::date = now()::date) as letters_printed_today;
