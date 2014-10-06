<?php
//----Fri 25 Oct 2013----remove HGB fix
//----Mon 23 Sep 2013----nb HB converted to HGB elsewhere
//-------CONFIG-----------
$limitno=false; //or FALSE
$resultsheader="Haematology"; //e.g. Haematol, Biochem, etc
//desired fields ***NB resultsdate automatically 1st column
//follow code with * to bold the column
$pathfieldslist=array(
	//'HGB*',
	'MCV',
	'MCH',
	'RETA',
	'HYPO',
	'WBC',
	'LYM',
	'NEUT',
	'PLT*',
	'ESR',
	'CRP*',
	'FER',
	'FOL',
	'B12',
	);
include 'incl/obxcodelist.php';
include 'incl/render_haemrows.php';
