/*
This is a pivoted crosstab view taking POS-S renal questionnaire responses from
patients and returning them with the question codes as the column headings.
See also the eq5d_5l for comments about alternative use of crosstab function.
*/
SELECT  r.answered_on,
        r.patient_id,
        sum(convert_to_float(r.value))::integer as "total_score",
        MAX(CASE WHEN q.code = 'YSQ1' THEN r.value ELSE NULL END) AS "YSQ1",
        MAX(CASE WHEN q.code = 'YSQ2' THEN r.value ELSE NULL END) AS "YSQ2",
        MAX(CASE WHEN q.code = 'YSQ3' THEN r.value ELSE NULL END) AS "YSQ3",
        MAX(CASE WHEN q.code = 'YSQ4' THEN r.value ELSE NULL END) AS "YSQ4",
        MAX(CASE WHEN q.code = 'YSQ5' THEN r.value ELSE NULL END) AS "YSQ5",
        MAX(CASE WHEN q.code = 'YSQ6' THEN r.value ELSE NULL END) AS "YSQ6",
        MAX(CASE WHEN q.code = 'YSQ7' THEN r.value ELSE NULL END) AS "YSQ7",
        MAX(CASE WHEN q.code = 'YSQ8' THEN r.value ELSE NULL END) AS "YSQ8",
        MAX(CASE WHEN q.code = 'YSQ9' THEN r.value ELSE NULL END) AS "YSQ9",
        MAX(CASE WHEN q.code = 'YSQ10' THEN r.value ELSE NULL END) AS "YSQ10",
        MAX(CASE WHEN q.code = 'YSQ11' THEN r.value ELSE NULL END) AS "YSQ11",
        MAX(CASE WHEN q.code = 'YSQ12' THEN r.value ELSE NULL END) AS "YSQ12",
        MAX(CASE WHEN q.code = 'YSQ13' THEN r.value ELSE NULL END) AS "YSQ13",
        MAX(CASE WHEN q.code = 'YSQ14' THEN r.value ELSE NULL END) AS "YSQ14",
        MAX(CASE WHEN q.code = 'YSQ15' THEN r.value ELSE NULL END) AS "YSQ15",
        MAX(CASE WHEN q.code = 'YSQ16' THEN r.value ELSE NULL END) AS "YSQ16",
        MAX(CASE WHEN q.code = 'YSQ17' THEN r.value ELSE NULL END) AS "YSQ17",
        MAX(CASE WHEN q.code = 'YSQ18' THEN r.value ELSE NULL END) AS "YSQ18",
        MAX(CASE WHEN q.code = 'YSQ19' THEN r.value ELSE NULL END) AS "YSQ19",
        MAX(CASE WHEN q.code = 'YSQ20' THEN r.value ELSE NULL END) AS "YSQ20",
        MAX(CASE WHEN q.code = 'YSQ21' THEN r.value ELSE NULL END) AS "YSQ21",
        MAX(CASE WHEN q.code = 'YSQ22' THEN r.value ELSE NULL END) AS "YSQ22",
        MAX(CASE WHEN q.code = 'YSQ18' THEN r.patient_question_text ELSE NULL END) AS "YSQ18_patient_question_text",
        MAX(CASE WHEN q.code = 'YSQ19' THEN r.patient_question_text ELSE NULL END) AS "YSQ19_patient_question_text",
        MAX(CASE WHEN q.code = 'YSQ20' THEN r.patient_question_text ELSE NULL END) AS "YSQ20_patient_question_text"
    FROM survey_responses r
    inner JOIN survey_questions q ON q.id = r.question_id
    inner JOIN survey_surveys s ON s.id = q.survey_id
WHERE s.code = 'prom'
GROUP BY r.answered_on, r.patient_id
ORDER BY r.answered_on DESC;
