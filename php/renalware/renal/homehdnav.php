<?php
//Sun May 10 14:38:12 CEST 2009
//set subnav items
$homehdmodes = array (
'assessment' => 'Home Haemo Assessment',
);
$mode = ($mode) ? $mode : "assessment" ;
?>
<div class="buttonsdiv">
<?php
	foreach ($homehdmodes as $key => $value) {
		$color = ($key==$mode) ? "red" : "#333" ;
		echo '<a style="color: '.$color.';" href="renal/renal.php?zid=' . $zid . '&amp;scr=homehdnav&amp;mode=' . $key . '">' . $value . '</a>';
	}
?>
</div>
<?php
//get mode page
include("homehd/$mode.php");
?>