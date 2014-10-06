<?php
//----Mon 23 Sep 2013---- HGB fix
//-------CONFIG-----------
$limitno=10; //or FALSE
$resultsheader="Patient Summary"; //e.g. Haematol, Biochem, etc
//desired fields ***NB resultsdate automatically 1st column
//follow code with * to bold the column
$pathfieldslist=array(
//	'HB^',
	'RETA',
	'HYPO',
	'WBC',
	'PLT',
	'FER',
	'URE*',
	'CRE*',
	'NA',
	'POT',
	'BIC',
	'CCA*',
	'PHOS',
	'PTHI',
	'TP',
	'GLO',
	'ALB',
	'URAT',
	'BIL',
	'ALT',
	'ALP',
	'GGT',
	'BGLU',
	'HBAI',
	'CRP',
	'CHOL',
	'URR',
	'CRCL',
	'UREP',
	'CYA',
	'AL',
	);
include 'incl/obxcodelist.php';
include 'incl/render_resultsdatarows.php';
