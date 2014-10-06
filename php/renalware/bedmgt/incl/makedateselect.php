<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
$months = array (1 => 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
$days = range(1, 31);
$years = range(2007, 2010);
//
echo '<select name="' .$fieldname . '_day">';

//assumes datestuff.php
	echo "<option value=\"\">day</option>\n";
//	echo "<option value=\"$todayday\">$todayday</option>\n";
foreach ($days as $key => $value) {
	echo "<option value=\"$value\">$value</option>\n";
}
echo '</select>&nbsp;&nbsp;';
echo '<select name="' .$fieldname . '_month">';
//assumes datestuff.php
	echo "<option value=\"\">month</option>\n";
//	echo "<option value=\"$thismonthno\">$thismonth</option>\n";
foreach ($months as $key => $value) {
	echo "<option value=\"$key\">$value</option>\n";
}
echo '</select>&nbsp;&nbsp;';
echo '<select name="' .$fieldname . '_year">';
	echo "<option value=\"\">year</option>\n";
	echo "<option value=\"$thisyear\">$thisyear</option>\n";
foreach ($years as $key => $value) {
	echo "<option value=\"$key\">$value</option>\n";
}
echo '</select>';

?>