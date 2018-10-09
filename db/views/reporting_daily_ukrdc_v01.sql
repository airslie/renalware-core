select
  (select count(*) from patients where sent_to_ukrdc_at::date = current_date) as patients_sent_to_ukrdc_today;
