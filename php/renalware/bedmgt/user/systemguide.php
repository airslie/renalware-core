<table cellpadding="8"><tr>
<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
include( 'nav/vwslist.php' );
foreach ($vwslist as $key => $value) {
	$vw=$key;
	echo "<td valign=\"top\"><b>$value</b><br>";
	include( 'nav/' . $vw . '.php' );
	foreach ($scrs as $key => $value) {
	echo "<li><a href=\"index.php?$key\">$value</a></li>";
	}
	echo "</td>";
}
?>
</tr></table>