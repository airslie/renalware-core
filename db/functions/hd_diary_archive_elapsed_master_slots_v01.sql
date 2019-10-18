CREATE OR REPLACE FUNCTION renalware.hd_diary_archive_elapsed_master_slots()
RETURNS void
  AS $$
  BEGIN

INSERT into hd_diary_slots
(
    diary_id,
    station_id,
    day_of_week,
    diurnal_period_code_id,
    patient_id,
    created_by_id,
    updated_by_id,
    created_at,
    updated_at,
    deleted_at
)
(
    select
        weekly_diary_id,
        station_id,
        day_of_week,
        diurnal_period_code_id,
        patient_id,
        master_slot_created_by_id,
        master_slot_updated_by_id,
        master_slot_created_at,
        master_slot_updated_at,
        deleted_at
    from renalware.hd_diary_matrix -- a SQL view
    where  weekly_slot_id is null and master_slot_id  is not null and master_slot_created_at <= slot_date
);

END;
$$ LANGUAGE plpgsql;
