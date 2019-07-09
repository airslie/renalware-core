-- This view is PD-specific, but really serevers to make UKRDC export easier.
-- It attempts to solve the gnarly problem of finding the pd regime associated with the start
-- of a PD modality. For example if a patient goes on to PD, a PD regime row is created.
-- However it could be a couple of weeks before they have a the PD regime setup. This view
-- attempts to find that association.
-- We need to know this association so when we export the modality as a UKRDC
-- Treatment, we can pull in the pd type (CAPD etc) from the regime.
-- Sometimes we will not be able to resolve a regime for the patient however.

WITH pd_modalities AS (
    SELECT
        m.patient_id,
        m.id AS modality_id,
        m.started_on,
        m.ended_on
    FROM
        modality_modalities m
        INNER JOIN modality_descriptions md ON md.id = m.description_id
    WHERE
        md.name = 'PD'
),
distinct_pd_regimes AS (
    -- selects the last regime created for a patient on any one day as there can be
    -- many iterations of a regime as it is refined/edited by the clinician.
    -- We can assume the final iteration on that day is the final one.
    -- If it was changed the next day then no bother
    SELECT DISTINCT ON (patient_id, start_date)
        id AS pd_regime_id,
        patient_id,
        start_date,
        end_date,
        created_at
    FROM
        pd_regimes
    ORDER BY
        -- Note the last order by (created_at) is required otherwsie we are only ordering by
        -- date - and since there might be several on the same day, the order is undefined.
        -- Feel free to run just this select statmment to understand the limitations
        patient_id, start_date asc, created_at desc
)
-- Note in this last select we select the earlist pd regime we find that matches
-- as sometimes there can be > 1 regime returned from distinct_pd_regimes
SELECT
    m.*,
    (
        SELECT
            pd_regime_id
        FROM
            distinct_pd_regimes pdr
        WHERE
            pdr.patient_id = m.patient_id
            AND( pdr.end_date IS NULL
                OR pdr.end_date > m.started_on)
             AND pdr.start_date <= (m.started_on + interval '2 weeks')::date
        ORDER BY
            created_at ASC
        LIMIT 1) AS pd_regime_id
FROM
    pd_modalities m order by m.patient_id;
