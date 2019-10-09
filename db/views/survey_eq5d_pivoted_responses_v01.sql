/*
This is a pivoted crosstab view taking EQ5D-5L (ie version 5L of the EQ5D health status spec)
responses from patients and returning them with the question codes as the column headings.
This view lets us display a table of EQ5D quentionnaire/survey responses by date
ie select * from renalware.eq5d5l_pivoted_responses where patient_id = 1
Note tha a future version of EQ5D will be another survey and require another version
of this view to return its data.
ALso note than here we use a rather rudimentary pivot mechincam rather than the more
sophisticated built-in PG crosstab() function. The latter I have found slower with large
numbers of records, and harder to implement a group by date *and* patient_id.
Here is how it might look however, without the grouping by patient_id:
SELECT
    *
FROM
    crosstab ('select answered_on, patient_id, q.code, value from responses r inner
              join questions q on r.question_id = q.id order by 1,2',
        'select code from questions order by 1')
    AS (
        answered_on date,
        patient_id INTEGER,
        YOHQ1 TEXT,
        YOHQ2 TEXT,
        YOHQ3 TEXT,
        YOHQ4 text,
        YOHQ5 text,
        YOHQ6 text);
*/
SELECT r.answered_on,
        r.patient_id,
         MAX(CASE WHEN q.code = 'YOHQ1' THEN r.value ELSE NULL END) AS "YOHQ1",
         MAX(CASE WHEN q.code = 'YOHQ2' THEN r.value ELSE NULL END) AS "YOHQ2",
         MAX(CASE WHEN q.code = 'YOHQ3' THEN r.value ELSE NULL END) AS "YOHQ3",
         MAX(CASE WHEN q.code = 'YOHQ4' THEN r.value ELSE NULL END) AS "YOHQ4",
         MAX(CASE WHEN q.code = 'YOHQ5' THEN r.value ELSE NULL END) AS "YOHQ5",
         MAX(CASE WHEN q.code = 'YOHQ6' THEN r.value ELSE NULL END) AS "YOHQ6"
    FROM survey_responses r
    inner JOIN survey_questions q ON q.id = r.question_id
    inner JOIN survey_surveys s ON s.id = q.survey_id
WHERE s.code = 'eq5d'
GROUP BY r.answered_on, r.patient_id
ORDER BY r.answered_on DESC;
