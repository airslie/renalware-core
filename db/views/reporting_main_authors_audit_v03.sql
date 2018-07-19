WITH archived_clinic_letters AS (
    SELECT
      date_part('year' :: text, archive.created_at)                                                 AS year,
      to_char(archive.created_at, 'Month' :: text)                                                  AS month,
      letters.author_id,
      date_part('day' :: text, (archive.created_at - (visits.date) :: timestamp without time zone)) AS days_to_archive
    FROM ((letter_letters letters
      JOIN letter_archives archive ON ((letters.id = archive.letter_id)))
      JOIN clinic_visits visits ON ((visits.id = letters.event_id)))
    WHERE (archive.created_at > (CURRENT_DATE - '3 mons' :: interval))
), archived_clinic_letters_stats AS (
    SELECT
      --archived_clinic_letters.year,
      --archived_clinic_letters.month,
      archived_clinic_letters.author_id,
      count(*)                                                                   AS total_letters,
      round(avg(archived_clinic_letters.days_to_archive))                        AS avg_days_to_archive,
      ((SELECT count(*) AS count
        FROM archived_clinic_letters acl
        WHERE ((acl.days_to_archive <= (7) :: double precision) AND
               (acl.author_id = archived_clinic_letters.author_id)))) :: numeric AS archived_within_7_days
    FROM archived_clinic_letters
    GROUP BY archived_clinic_letters.author_id
)

SELECT
  (((users.family_name) :: text || ', ' :: text) || (users.given_name) :: text)                 AS name,
  stats.total_letters,
  round(((stats.archived_within_7_days / (stats.total_letters) :: numeric) *
         (100) :: numeric))                                                                     AS percent_archived_within_7_days,
  stats.avg_days_to_archive,
  users.id as user_id
FROM (archived_clinic_letters_stats stats
  JOIN users ON ((stats.author_id = users.id)))
--GROUP BY (((users.family_name)::text || ', '::text) || (users.given_name)::text), users.id, stats.total_letters, stats.avg_days_to_archive, stats.archived_within_7_days
ORDER BY stats.total_letters desc
