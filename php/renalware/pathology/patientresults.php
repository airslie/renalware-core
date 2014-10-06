<?php
//----Mon 23 Sep 2013----HGB fix
//-------CONFIG-----------
$limitno=false; //or FALSE
$resultsheader="Archived"; //e.g. Haematol, Biochem, etc
//desired fields ***NB resultsdate automatically 1st column
//follow code with * to bold the column
$pathfieldslist=array(
//	'HB*',
	'MCV',
	'MCH',
	'RETA',
	'HYPO',
	'WBC',
	'LYM',
	'NEUT',
	'PLT',
	'ESR',
	'CRP',
	'FER',
	'FOL',
	'B12',
	'URE*',
	'CRE*',
	'EGFR*',
	'NA',
	'POT*',
	'BIC*',
	'CCA',
	'PHOS',
	'PTHI',
	'TP',
	'GLO',
	'ALB',
	'URAT',
	'BIL',
	'ALT',
	'AST',
	'ALP',
	'GGT',
	'BGLU',
	'HBA',
	'HBAI*',
	'CHOL',
	'HDL*',
	'LDL',
	'TRIG',
	'TSH',
	'CK',
	'URR*',
	'CRCL',
	'UREP',
	'AL',
	);
include 'incl/obxcodelist.php';
include 'incl/render_resultsdatarows.php';
