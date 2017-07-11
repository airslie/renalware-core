with
    archived_clinic_letters as (
      select
        extract(year from archive.created_at) as year,
        to_char(archive.created_at, 'Month') as month,
        letters.author_id as author_id,
        DATE_PART('day', archive.created_at - visits.date) as days_to_archive
      from letter_letters as letters
      inner join letter_archives as archive on letters.id = archive.letter_id
      inner join clinic_visits visits on visits.id = letters.event_id
      where archive.created_at > (current_date - interval '3 months')
     ),
   archived_clinic_letters_stats as (
    select
    archived_clinic_letters.year,
    archived_clinic_letters.month,
    archived_clinic_letters.author_id,
    count(*) as total_letters,
    round(avg(days_to_archive)) as avg_days_to_archive,     (select count(*)
      from archived_clinic_letters acl
      where acl.days_to_archive <=7
        and acl.author_id = archived_clinic_letters.author_id)::numeric as archived_within_7_days
    from archived_clinic_letters
    group by archived_clinic_letters.year, archived_clinic_letters.month, archived_clinic_letters.author_id
   )

 select
    (users.family_name || ', ' || users.given_name) AS name,
    stats.total_letters,
    ROUND(((stats.archived_within_7_days / stats.total_letters) * 100)) as percent_archived_within_7_days,
    stats.avg_days_to_archive,
    users.id as user_id
    from archived_clinic_letters_stats as stats
    inner join users on stats.author_id = users.id
    group by name, user_id, stats.total_letters, stats.avg_days_to_archive, stats.archived_within_7_days
    order by stats.total_letters
