<?php
//----Thu 24 Feb 2011----
//----Thu 24 Feb 2011----'arcdiagnosis'=>'x^Primary (ARC) Diagnosis', DEPREC
$arcdatamap=array(
	'arc_id'=>'x^ID',
	'arcstamp'=>'x^added',
	'arcmodifstamp'=>'x^updated',
	'arcuid'=>'x^UID',
	'arcuser'=>'x^user',
	'arczid'=>'x^ZID',
	'arcadddate'=>'x^add date',
	'arcmodifdate'=>'x^modif date',
	'whereseen'=>'s^where seen',
	'surveyconsentflag'=>'f^Survey consent?',
	'ihdflag'=>'f^Isch Heart Dis',
	'pvdflag'=>'f^PVD',
	'dementiaflag'=>'f^dementia',
	'lowalbuminflag'=>'f^low albumin',
	'myeloma_cancerflag'=>'f^myeloma/cancer',
	//'weightlossflag'=>'f^weight loss',
	'surpriseflag'=>'f^surprised?',
	'surprisedate'=>'c^surprise updated',
	'karnofskyscore'=>'s^Modif Karnovsky Score',
	//'symptoms'=>'a6x70^symptoms',
	'patientfamilylog'=>'a6x70^patient/family',
	'healthproviderlog'=>'a6x70^health provider',
	'goldregisterflag'=>'f^Gold Register suitable',
	'golddiscussedflag'=>'f^GR discussed/consented',
	'goldacpflag'=>'f^ACP offered/undertaken',
	'goldecommregisterflag'=>'f^Electr commun register',
	'arcplanninglog'=>'a6x70^ARC planning',
	'endoflifeplans'=>'a6x50^End of Life plans',
	'placeofcareprefs'=>'a3x70^place of care prefs',
	'counsellorrefflag'=>'f^counsellor referral',
	'counsellorrefdate'=>'c^counsellor ref date',
	'counsellorcomments'=>'a3x70^counsellor comments',
	'socialworkerrefflag'=>'f^social worker referral',
	'socialworkerrefdate'=>'c^social worker ref date',
	'socialworkercomments'=>'a6x70^social worker comments',
	'hospicerefflag'=>'f^hospice referral',
	'hospicerefdate'=>'c^hospice ref date',
	'hospicename'=>'s^hospice name',
	'deathdate'=>'c^death date',
	'deathplace'=>'t70^death place',
	'deathcause'=>'t70^death cause',
	'bereavementnotes'=>'a6x70^bereavement notes',
	'questionnairesentflag'=>'f^questionnaire sent',
	'questionnairedate'=>'c^questionnaire date',
	'archistory'=>'a6x70^ARC notes/log',
	);
	$showarcfields=array(
			'header0'=>'0^ARC--BACKGROUND INFO',
			'age'=>'x^age',
			'whereseen'=>'s^where seen',
			'surpriseflag'=>'f^surprised?',
			'surprisedate'=>'c^surprise updated',
			'arcdiagnosis'=>'x^Primary (Renal) Diagnosis',
			'surveyconsentflag'=>'f^Survey consent?',
			'ihdflag'=>'f^Isch Heart Dis',
			'pvdflag'=>'f^PVD',
			'dementiaflag'=>'f^dementia',
			'lowalbuminflag'=>'f^low albumin',
			'myeloma_cancerflag'=>'f^myeloma/cancer',
			'karnofskyscore'=>'s^Modif Karnovsky Score',
			'patientfamilylog'=>'a6x50^patient/family',
			'healthproviderlog'=>'a6x50^health provider',
			'header1'=>'0^CAUSE FOR CONCERN/ADVANCE CARE PLANNING (GOLD REGISTER)',
			'goldregisterflag'=>'f^Gold Register suitable',
			'golddiscussedflag'=>'f^GR discussed/consented',
			'goldacpflag'=>'f^ACP offered/undertaken',
			'goldecommregisterflag'=>'f^Electr commun register',
			'header2'=>'0^PLANNING &amp; PREFERENCES',
			'arcplanninglog'=>'a6x50^ARC planning',
			'endoflifeplans'=>'a6x50^End of Life plans',
			'placeofcareprefs'=>'a3x50^place of care prefs',
			'header3'=>'0^REFERRALS',
			'counsellorrefflag'=>'f^counsellor referral',
			'counsellorrefdate'=>'c^counsellor ref date',
			'counsellorcomments'=>'a3x50^counsellor comments',
			'socialworkerrefflag'=>'f^social worker referral',
			'socialworkerrefdate'=>'c^social worker ref date',
			'socialworkercomments'=>'a6x50^social worker comments',
			'hospicerefflag'=>'f^hospice referral',
			'hospicerefdate'=>'c^hospice ref date',
			'hospicename'=>'s^hospice name',
			'header4'=>'0^DEATH &amp; BEREAVEMENT',
			'deathdate'=>'c^death date',
			'deathplace'=>'t60^death place',
			'deathcause'=>'t60^death cause',
			'bereavementnotes'=>'a6x50^bereavement notes',
			'header5'=>'0^QUESTIONNAIRE',
			'questionnairesentflag'=>'f^questionnaire sent',
			'questionnairedate'=>'c^questionnaire date',
			'header6'=>'0^ARC NOTES &amp; COMMENTS',
			'archistory'=>'a6x50^ARC notes/log',
			);
			
$eq5ddatamap=array(
	'eq5d_id'=>'x^ID',
	'eq5dstamp'=>'x^added',
	'eq5duid'=>'x^UID',
	'eq5duser'=>'x^user',
	'eq5dzid'=>'x^ZID',
	'eq5dadddate'=>'x^add date',
	'eq5ddate'=>'c^survey date',
	'mobility'=>'r^Mobility',
	'selfcare'=>'r^Self-Care',
	'activities'=>'r^Usual Activities',
	'pain_discomfort'=>'r^Pain/Discomfort',
	'anxiety_depress'=>'r^Anxiety/Depression',
	'healthstate'=>'t4^Health State',
);
/*
----Sun 05 Jun 2011----removed
'seriousillness_self'=>'f^Serious illness--self',
'seriousillness_family'=>'f^Serious illness--family',
'seriousillness_others'=>'f^Serious illness--others',
'currage'=>'t3^currage',
'gender'=>'r^gender',
'smoking'=>'r^smoking',
'healthsocialworker'=>'f^healthcare/social worker',
'healthsocialworktype'=>'t70^healthcare/social work--type',
'mainactivity'=>'r^Main Activity',
'mainactivity_other'=>'t70^Main Activity--other',
'continuededuc'=>'f^Continued Educ',
'degree_qualif'=>'f^Degree/Qualific',
'postcode'=>'t12^postcode',
*/
$showeq5ddatafields=array(
	'eq5ddate'=>'c^survey date',
	'mobility'=>'r^Mobility',
	'selfcare'=>'r^Self-Care',
	'activities'=>'r^Usual Activities',
	'pain_discomfort'=>'r^Pain/Discomfort',
	'anxiety_depress'=>'r^Anxiety/Depression',
	'healthstate'=>'t4^Health State',
	'eq5dstamp'=>'x^entered',
	'eq5duser'=>'x^entered by',
);
$karnofskyscore_options='';
for ($i=0; $i < 11; $i++) { 
	$score=10*$i;
	$karnofskyscore_options.="<option>$score</option>";
}
//NB z type below for POSS scoring system
$possdatamap=array(
	'poss_id'=>'x^ID',
	'possstamp'=>'x^added',
	'possuid'=>'x^UID',
	'possuser'=>'x^user',
	'posszid'=>'x^ZID',
	'possadddate'=>'x^add date',
	'possdate'=>'c^Questionnaire Date',
	'pain'=>'z^Pain',
	'shortness_of_breath'=>'z^Shortness of breath',
	'weakness'=>'z^Weakness',
	'nausea'=>'z^Nausea',
	'vomiting'=>'z^Vomiting',
	'poor_appetite'=>'z^Poor appetite',
	'constipation'=>'z^Constipation',
	'mouth_problems'=>'z^Mouth problems',
	'drowsiness'=>'z^Drowsiness',
	'poor_mobility'=>'z^Poor mobility',
	'itching'=>'z^Itching',
	'insomnia'=>'z^Difficulty sleeping',
	'restless_legs'=>'z^Restless legs',
	'anxiety'=>'z^Feeling anxious',
	'depression'=>'z^Feeling depressed',
	'skinchanges'=>'z^Changes in skin',
	'diarrhoea'=>'z^Diarrhoea',
	'othersymptom1'=>'t30^Other Symptom(1)',
	'othersymptom1score'=>'z^Other(1) score',
	'othersymptom2'=>'t30^Other Symptom(2)',
	'othersymptom2score'=>'z^Other(2) score',
	'othersymptom3'=>'t30^Other Symptom(3)',
	'othersymptom3score'=>'z^Other(3) score',
	'affected_most'=>'s^Affected most',
	'improved_most'=>'s^Improved most',
);
$showpossdatafields=array(
	'possadddate'=>'x^add date',
	'possdate'=>'c^Questionnaire Date',
	'pain'=>'z^Pain',
	'shortness_of_breath'=>'z^Shortness of breath',
	'weakness'=>'z^Weakness',
	'nausea'=>'z^Nausea',
	'vomiting'=>'z^Vomiting',
	'poor_appetite'=>'z^Poor appetite',
	'constipation'=>'z^Constipation',
	'mouth_problems'=>'z^Mouth problems',
	'drowsiness'=>'z^Drowsiness',
	'poor_mobility'=>'z^Poor mobility',
	'itching'=>'z^Itching',
	'insomnia'=>'z^Difficulty sleeping',
	'restless_legs'=>'z^Restless legs',
	'anxiety'=>'z^Feeling anxious',
	'depression'=>'z^Feeling depressed',
	'skinchanges'=>'z^Changes in skin',
	'diarrhoea'=>'z^Diarrhoea',
	'othersymptom1'=>'t30^Other Symptom(1)',
	'othersymptom1score'=>'z^Other(1) score',
	'othersymptom2'=>'t30^Other Symptom(2)',
	'othersymptom2score'=>'z^Other(2) score',
	'othersymptom3'=>'t30^Other Symptom(3)',
	'othersymptom3score'=>'z^Other(3) score',
	'affected_most'=>'s^Affected most',
	'improved_most'=>'s^Improved most',
);
//----Fri 11 Mar 2011----NB Special handling of these:
/*
	'other1'=>'t30^Other1',
	'other2'=>'t30^Other2',
	'other3'=>'t30^Other3',
	'other1score'=>'z^Other1score',
	'other2score'=>'z^Other2score',
	'other3score'=>'z^Other3score',
	'affected_most'=>'t30^Affected most',
	'improved_most'=>'t30^Improved most',
*/
//optionlists
$whereseenarray=array(
	'KCH clinic',
	'QEH outreach',
	'DVH outreach',
	'Home visits',
);
$hospicenamearray=array(
	"St Christopher's",
	"Ellenor-Lions Hospice",
	"Greenwich & Bexley",
	"Harris",
	"Trinity",
	"Other",
);

$mobilityarray=array(
	'no problems',
	'some problems',
	'confined to bed',
);

$selfcarearray=array(
	'no problems',
	'some problems',
	'unable to wash/dress',
);

$activitiesarray=array(
	'no problems',
	'some problems',
	'unable to perform',
);

$pain_discomfortarray=array(
	'none',
	'moderate',
	'extreme',
);

$anxiety_depressarray=array(
	'none',
	'moderate',
	'extreme',
);
$mainactivityarray=array(
	'employed',
	'retired',
	'housework',
	'student',
	'seeking work',
);

$genderarray=array(
	'M',
	'F',
);

$smokingarray=array(
	'current',
	'ex-smoker',
	'never',
);


$possoptionsarray=array(
	'Not at all',
	'Slightly',
	'Moderately',
	'Severely',
	'Overwhelmingly'
);
$possnumoptionsarray=array(
	'0'=>'Not at all',
	'1'=>'Slightly',
	'2'=>'Moderately',
	'3'=>'Severely',
	'4'=>'Overwhelmingly'
);

$optionfields=array('mobility','selfcare','activities','pain_discomfort','anxiety_depress','gender','smoking','mainactivity','whereseen','hospicename');

foreach ($optionfields as $fld) {
	$fldarray=${$fld.'array'};
	${$fld.'_options'}="";
	foreach ($fldarray as $option) {
		${$fld.'_options'}.="<option>$option</option>";
	}
}

$possoptions='<option value="pain">Pain</option>
<option value="shortness_of_breath">Shortness of breath</option>
<option value="weakness">Weakness</option>
<option value="nausea">Nausea</option>
<option value="vomiting">Vomiting</option>
<option value="poor_appetite">Poor appetite</option>
<option value="constipation">Constipation</option>
<option value="mouth_problems">Mouth problems</option>
<option value="drowsiness">Drowsiness</option>
<option value="poor_mobility">Poor mobility</option>
<option value="itching">Itching</option>
<option value="insomnia">Difficulty sleeping</option>
<option value="restless_legs">Restless legs</option>
<option value="anxiety">Feeling anxious</option>
<option value="depression">Feeling depressed</option>
<option value="skinchanges">Changes in skin</option>
<option value="diarrhoea">Diarrhoea</option>
<option value="other1">Other Symptom(1)</option>
<option value="other2">Other Symptom(2)</option>
<option value="other3">Other Symptom(3)</option>';

$affected_most_options=$possoptions;
$improved_most_options=$possoptions;
?>