<?php
//----Sat 28 Dec 2013----simplified
//--Thu Dec 19 11:38:40 CET 2013--
$launchdate="Thu 19 Dec 2013"; //for occasional display; needs update on launch
$modulebase="aki";
$brandlabel="Renalware";
$modulelabel="AKI Module";
$pagetitles = array(
  'index' => 'Main Menu',
  'list_akiconsults' => 'AKI Consult Pats',
  'list_episodes' => 'AKI Episodes',
  'add_episode' => 'Add AKI Episode',
);

$pagedescrs = array(
  'index' => 'Main Menu (this page)',
  'list_akiconsults' => 'Current AKI Consult Pats',
  'list_episodes' => 'AKI Episodes',
  'add_episode' => 'Add AKI Episode',
);

$akidatamap=array(
    'aki_id'=>'x^aki_id',
    'akistamp'=>'x^created',
    'akimodifdt'=>'x^updated',
    'akiuid'=>'x^UID',
    'akiuser'=>'x^User',
    'akizid'=>'x^ZID',
    'akiadddate'=>'x^added',
    'akimodifdate'=>'x^modified',
    'episodedate'=>'c^episode date',
    'episodestatus'=>'s^episode status',
    'referraldate'=>'c^referral date',
    'admissionmethod'=>'s^admission method',
    'elderlyscore'=>'n^elderly?',
    //'existingckdscore'=>'n^existing CKD?',
    'ckdstatus'=>'s^CKD Status?',
    'cardiacfailurescore'=>'n^cardiac failure?',
    'diabetesscore'=>'n^diabetes?',
    'liverdiseasescore'=>'n^liver disease?',
    'vasculardiseasescore'=>'n^vascular disease?',
    'nephrotoxicmedscore'=>'n^nephrotoxic meds?',
    'akiriskscore'=>'x^AKI Risk Score',
    'cre_baseline'=>'t5^Baseline CRE',
    'cre_peak'=>'t5^Peak CRE',
    'egfr_baseline'=>'t5^baseline eGFR',
    'urineoutput'=>'s^urine output',
    'urineblood'=>'s^urine blood',
    'urineprotein'=>'s^urine protein',
    'akinstage'=>'x^AKIN Score',
    'stopdiagnosis'=>'s^STOP diagnosis',
    'stopsubtype'=>'s^STOP subtype',
    'stopsubtypenotes'=>'t100^STOP notes',
    'akicode'=>'x^AKI code',
    'ituflag'=>'f^ITU?',
    'itudate'=>'c^ITU date',
    'renalunitflag'=>'f^renal unit?',
    'renalunitdate'=>'c^renal unit date',
    'itustepdownflag'=>'f^ITU stepdown?',
    'rrtflag'=>'f^RRT in Renal Unit?',
    'rrttype'=>'s^RRT Type',
    'rrtduration'=>'s^RRT duration',
    'rrtnotes'=>'t50^RRT descr',
    'mgtnotes'=>'a6x70^Management Notes',
    'akioutcome'=>'s^Outcome',
    'ussflag'=>'f^USS?',
    'ussdate'=>'c^USS date',
    'ussnotes'=>'a6x70^USS results',
    'biopsyflag'=>'f^biopsy?',
    'biopsydate'=>'c^biopsy date',
    'biopsynotes'=>'a6x70^biopsy results',
    'otherix'=>'a6x70^other Investigations',
    'akinotes'=>'a6x70^AKI notes/comments',
	);