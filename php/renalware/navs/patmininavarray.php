<?php
//updated 
	$patnav = array (
		'../pat/patient.php?vw=admin' => 'Admin',
		'../pat/patient.php?vw=clinsumm' => 'ClinSumm',
		'../pat/patient.php?vw=admissions' => "Adm&rsquo;ns",
		'../pat/patient.php?vw=pimsdata' => "PIMS",
		'../pat/patient.php?vw=letters' => "Lttrs",
		'../pat/patient.php?vw=encounters' => "Encs",
		'../pat/patient.php?vw=meds' => "Meds",
		'../pat/patient.php?vw=problems' => "Probs",
		'../pat/patient.php?vw=modals' => "Modals",
		'../pat/patient.php?vw=bpwtdata' => "Ht/BP/Wt",
		'../pat/patient.php?vw=ixworkups' => "Ix/Workups",
		'../pat/patient.php?vw=pathol' => "Pathol",
		'../pat/patient.php?vw=proceds' => "Ops",
		'../pat/patient.php?vw=psychsocial' => "Psych/Social",
		'../pat/patient.php?vw=hl7events' => "PIMS"
		);
$pagetitle= $patnav[$vw] . ' -- ' . $titlestring;
//set mod to select vwbar options
$baseurl="../pat/patient.php?zid=$zid";
?>
<div id="patnavdiv">
	<p>
	<?php
	foreach ($patnav as $key => $value) {
		$parts = explode("=", $key);
		$style = ($parts[1]==$vw) ? "color: red; background: yellow;" : "color: #333" ;
		echo '<a class="ui-state-default" style="'.$style.'" href="' . $key . '&amp;zid=' . $zid . '">' . $value . '</a>&nbsp;&nbsp;';
		}
	?>
	</p>
</div>