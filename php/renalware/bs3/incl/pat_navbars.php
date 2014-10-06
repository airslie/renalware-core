<?php
//--Sun Nov 24 12:30:41 EST 2013--
$patnav = array (
	'admin' => 'Admin',
	'clinsumm' => 'ClinSumm',
	'admissions' => "Adm&rsquo;ns $count_admissions",
	'pimsdata' => "PIMS",
	'letters' => "Lttrs $count_letters",
	'encounters' => "Encs $count_encounters",
	'meds' => "Meds $count_meds",
	'problems' => "Probs $count_probs",
	'modals' => "Modals $count_modals",
	'bpwtdata' => "Ht/BP/Wt $count_bpwts",
	'ixworkups' => "Ix $count_ixdata",
	'pathology' => "Path $count_pathix",
	'proceds' => "Ops $count_ops",
	'psychsocial' => "Psych/Soc",
	);
//set mod to select vwbar options
$baseurl="pat/patient.php?zid=$zid";
//navbar
echo '<div class="btn-group btn-group-sm">';
echo '<button class="btn btn-warning" onclick="$(\'#patinfodiv\').toggle()">Toggle Info</button>';
foreach ($patnav as $key => $value) {
	$class = ($key==$vw) ? 'btn btn-primary' : 'btn btn-default' ;
	echo '<a class="'.$class.'" href="pat/patient.php?vw=' . $key . '&amp;zid=' . $zid . '">' . $value . '</a>';
	}
echo '</div>
<div id="patinfodiv" style="display: none;">';
include 'renalnav.php';
include 'clinpathdiv.php';
//allergies
if ($clinAllergies) {
    echo '<div class="alert alert-danger">ALLERGIES/INTOLERANCE: '.$clinAllergies.'</div>';
}
if ($alert) {
    echo '<div class="alert alert-warning">'.$alert.'</div>';
}
echo '</div>'; //end pat info div