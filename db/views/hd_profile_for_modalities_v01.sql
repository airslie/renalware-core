-- This view is HD-specific, but really serevers to make UKRDC export easier.
-- It attempts to solve the gnarly problem of finding the hd profile associated with the start
-- of an HD modality. For example if a patient goes on to HD, an HD modality row is created.
-- However it could be a couple of weeks before they have an HD profile setup. This view
-- attempts to find that association.
-- We need to know the association so when we export the modality as a UKRDC
-- Treatment, we can pull in the site, hd_type etc from the hd profile.
-- Sometimes we will not be able to resolve a profile for the patient however.
WITH hd_modalities AS (
    SELECT
        m.patient_id,
        m.id AS modality_id,
        m.started_on,
        m.ended_on
    FROM
        modality_modalities m
        INNER JOIN modality_descriptions md ON md.id = m.description_id
    WHERE
        md.name = 'HD'
),
distinct_hd_profiles AS (
    -- selects the last profile created for a patient on any one day as there can be
    -- many iterations of a profile as it is refined/edited by the clinician.
    -- We can assume the final iteration on that day is the final one.
    -- If it was changed the next day then no bother
    SELECT DISTINCT ON (patient_id, created_at::date)
        id AS hd_profile_id,
        patient_id,
        COALESCE(prescribed_on, created_at)::date AS effective_prescribed_on,
        prescribed_on,
        created_at::date AS created_on,
        created_at,
        deactivated_at,
        active
    FROM
        hd_profiles
    ORDER BY
        -- Note the last order by (created_at) is required otherwsie we are only ordering by
        -- date - and since there might be several on the same day, the order is undefined.
        -- Note we cannot use created_at as the 2nd sort as its type has to match the distinct on..
        -- so we have to cast it to a date here. Feel free to run just this select statmment to
        -- understand the limitations
        patient_id, created_at::date, created_at desc
)
-- Note in this last select we select the earlist hd profile we find that matches
-- as sometimes there can be > 1 hd profile returned from distinct_hd_profiles
SELECT
    m.*,
    (
        SELECT
            hd_profile_id
        FROM
            distinct_hd_profiles hp
        WHERE
            hp.patient_id = m.patient_id
            AND(hp.deactivated_at IS NULL OR deactivated_at > m.started_on)
            -- No longer limiting the look ahead to 2 weeks - there is now no future limit
            -- AND hp.created_on <= (started_on + interval '2 weeks')
        ORDER BY
            created_at ASC
        LIMIT 1) AS hd_profile_id
FROM
    hd_modalities m;
