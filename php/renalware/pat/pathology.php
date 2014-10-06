<?php
//Tue Dec  4 11:56:12 CET 2007
//set default
$scr = ($_GET['scr']) ? $_GET['scr'] : "currentpathdata" ;
$pid="$hospno1";
//set subnav items
$pathnav = array (
	'currentpathdata' => 'Current Pathol',
	'haematol' => 'Haematology',
	'biochem' => 'Biochemistry',
	'patientresults' => 'Archived Results',
	'resultsbrowser' => 'Investigations List',
	);
$baseurl="pat/patient.php?vw=pathology&amp;zid=$zid";
?>
<div class="buttonsdiv">
<?php
foreach ($pathnav as $key => $value) {
	$style = ($key==$scr) ? 'color: red; background: yellow' : "color: #333" ;
	echo '<a style="'.$style.'" href="' . $baseurl . '&amp;scr=' . $key . '">' . $value . '</a>&nbsp;&nbsp;';
	}
?>
</div>
<?php
include "$rwarepath/pathology/$scr.php";
?>