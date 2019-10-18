-- First build a matrix of 'virtual' empty slots - by creating a cartesian product
-- of weeks in the last year, unit, stations, days and periods (am pm eve)
-- This can creates 50,0000+ rows
with hd_empty_diary_matrix as (
    SELECT
        extract(YEAR from the_date) as year,
        extract(WEEK from the_date) as week_number,
        h.id as hospital_unit_id,
        s.id as station_id,
        day_of_week,
        period.id as diurnal_period_code_id
    from generate_series(now() - interval '1 year', now() - interval '1 week', '1 week') as the_date
    cross join hospital_units h
    cross join hd_stations s
    CROSS JOIN (SELECT generate_series(1, 7) AS day_of_week) as A
    CROSS JOIN hd_diurnal_period_codes period
    where h.is_hd_site = TRUE
    order by year, week_number, hospital_unit_id, station_id, day_of_week, diurnal_period_code_id
)
-- Now decorate the previous query by adding columns for the slots (master and weekly) that we actually have
select
    M.*
    ,WD.id as weekly_diary_id
    ,MD.id as master_diary_id
    ,WS.id as weekly_slot_id
    ,MS.id as master_slot_id
    ,coalesce(WS.patient_id, MS.patient_id) as patient_id
    ,MS.deleted_at
    ,MS.created_by_id as master_slot_created_by_id
    ,MS.updated_by_id as master_slot_updated_by_id
    ,MS.created_at::date as master_slot_created_at
    ,MS.updated_at::date as master_slot_updated_at
    ,to_date(WD.year::text || '-' ||  WD.week_number::text || '-' || MS.day_of_week::text , 'iyyy-iw-ID') slot_date
    from hd_empty_diary_matrix M
    left outer join hd_diaries WD on WD.hospital_unit_id = M.hospital_unit_id AND WD.year = M.year AND WD.week_number = M.week_number AND WD.master = false
    left outer join hd_diaries MD on MD.hospital_unit_id = M.hospital_unit_id AND MD.master = true
    left outer join hd_diary_slots WS on WS.diary_id = WD.id AND WS.station_id = M.station_id and WS.day_of_week = M.day_of_week AND WS.diurnal_period_code_id = M.diurnal_period_code_id
    left outer join hd_diary_slots MS on MS.diary_id = MD.id AND MS.station_id = M.station_id and MS.day_of_week = M.day_of_week AND MS.diurnal_period_code_id = M.diurnal_period_code_id
