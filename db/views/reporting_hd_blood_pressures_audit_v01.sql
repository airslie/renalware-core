/*
This is just a starter for 10 equivalent for the HaemoBPaudit4 audit.
Lots missing for example
- only do this for the last 30 days?
- selecting patients with a current modality of HD
- filtering out null or 0 bps
- the 140 130 etc percentages
*/

WITH
  blood_pressures AS (
  SELECT
    hd_sessions.id as session_id,
    patients.id as patient_id,
    hd_sessions.hospital_unit_id,
    hd_sessions.document->'observations_before'->'blood_pressure'->>'systolic' as systolic_pre,
    hd_sessions.document->'observations_before'->'blood_pressure'->>'diastolic' as diastolic_pre,
    hd_sessions.document->'observations_after'->'blood_pressure'->>'systolic' as systolic_post,
    hd_sessions.document->'observations_after'->'blood_pressure'->>'diastolic' as diastolic_post
    FROM hd_sessions
  INNER JOIN patients on patients.id = hd_sessions.patient_id
  WHERE hd_sessions.signed_off_at IS NOT NULL
  ),
  some_other_derived_table_variable AS (
   SELECT 1 FROM blood_pressures
  )
SELECT
  hu.name as hospital_unit_name,
  ROUND(AVG(systolic_pre::int)) as systolic_pre_avg,
  ROUND(AVG(diastolic_pre::int)) as diastolic_pre_avg,
  ROUND(AVG(systolic_post::int)) as systolic_post_avg,
  ROUND(AVG(diastolic_post::int)) as distolic_post_avg
  FROM blood_pressures
  INNER JOIN hospital_units as hu on hu.id = blood_pressures.hospital_unit_id
        GROUP BY hu.name

/*
Here is the original for reference
use audits;
DROP TABLE IF EXISTS hdbpdata;
DROP TABLE IF EXISTS hdpatbpavg;
DROP TABLE IF EXISTS hdpatbpsite;
DROP TABLE IF EXISTS HDpatBPsitemain;
SET @mintotal=6;
CREATE TEMPORARY TABLE hdbpdata SELECT hdsesszid, modalsite as currsite, sex,
year(CURDATE())-year(birthdate) as age, syst_pre, syst_post, diast_pre, diast_post FROM
renalware.hdsessiondata JOIN renalware.patientdata ON hdsesszid=patzid WHERE DATEDIFF(CURDATE(),
hdsessdate)<30 and patientdata.modalcode LIKE '%HD%';
CREATE TABLE hdpatbpavg as SELECT hdsesszid, currsite, ROUND(AVG(syst_pre),0) as avgpresyst,
ROUND(AVG(syst_post),0) as avgpostsyst, ROUND(AVG(diast_pre),0) as avgprediast,
 ROUND(AVG(diast_post),0) as avgpostdiast, syst_pre, syst_post, diast_pre, diast_post FROM hdbpdata
 GROUP BY hdsesszid;
CREATE TABLE hdpatbpsite as SELECT currsite as currentsite, count(hdsesszid) as patcount,
ROUND(AVG(avgpresyst),0) as presyst_avg,
round(100*(sum(IF(syst_pre<140, '1','0'))/count(hdsesszid)),1) as pctpresysless140,
ROUND(AVG(avgpostsyst),0) as postsys_avg,
round(100*(sum(IF(syst_post<130, '1','0'))/count(hdsesszid)),1) as pctpostsysless130,
ROUND(AVG(avgprediast),0) as prediast_avg,
round(100*(sum(IF(diast_pre<90, '1','0'))/count(hdsesszid)),1) as pctprediastless90,
ROUND(AVG(avgpostdiast),0) as postdiast_avg,
round(100*(sum(IF(diast_post<80, '1','0'))/count(hdsesszid)),1) as pctpostdiastless80
FROM hdpatbpavg GROUP BY currentsite
UNION
SELECT 'Total', count(hdsesszid) as patcount, ROUND(AVG(avgpresyst),0) as presyst_avg,
round(100*(sum(IF(syst_pre<140, '1','0'))/count(hdsesszid)),1) as pctpresysless140,
ROUND(AVG(avgpostsyst),0) as postsys_avg,
round(100*(sum(IF(syst_post<130, '1','0'))/count(hdsesszid)),1) as pctpostsysless130,
ROUND(AVG(avgprediast),0) as prediast_avg,
round(100*(sum(IF(diast_pre<90, '1','0'))/count(hdsesszid)),1) as pctprediastless90,
ROUND(AVG(avgpostdiast),0) as postdiast_avg,
round(100*(sum(IF(diast_post<80, '1','0'))/count(hdsesszid)),1) as pctpostdiastless80
FROM hdpatbpavg;
Create TABLE HDpatBPsitemain as select * from hdpatbpsite WHERE patcount>@mintotal
ORDER BY patcount DESC;
UPDATE auditslist SET lastrun=NOW() WHERE auditcode='hdbpaudit';
DROP TABLE IF EXISTS hdbpdata;
DROP TABLE IF EXISTS hdpatbpavg;
DROP TABLE IF EXISTS hdpatbpsite;
*/
