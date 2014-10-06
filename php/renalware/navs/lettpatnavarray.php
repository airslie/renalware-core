<p>
<?php
//navbar
$patnav = array (
	'admin' => 'Admin',
	'clinsumm' => 'Clin Summ',
	'admissions' => "Admissions",
	'letters' => "Letters",
	'encounters' => "Encounters",
	'meds' => "Meds",
	'problems' => "Probs",
	'modals' => "Modals",
	'bpwtdata' => "Ht/BPs/Wts",
	'ixworkups' => "Ix/Workups",
	'pathol' => "Pathol",
	'proceds' => "Ops/Proceds"
	);
foreach ($patnav as $vw => $lbl) {
	echo '<a class="ui-state-default" style="color: green;" href="pat/patient.php?vw='.$vw.'&amp;zid=' . $zid . '&amp;menu=hide&amp;win=new" target="new" onclick="window.open(this.href,this.target,\'width=1300,height=900,menubar=yes,status=no\'); return false;">' . $lbl . '</a>&nbsp;&nbsp;';
	}
?>
</p>