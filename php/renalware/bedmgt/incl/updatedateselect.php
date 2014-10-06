<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
$months = array (1 => 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
$days = range(1, 31);
$years = range(2006, 2009);
//curr data
//get $currymd = explode("-", $fieldname);
$currdd=$currymd[2];
$currmm=$currymd[1];
$curryyyy=$currymd[0];
//
echo '<select name="' . $fieldname . '_day">';
//insert any curr value
if ( $currymd )
	{
	echo "<option value=\"$currdd\">$currdd</option>\n";
	}
//assumes datestuff.php
	echo "<option value=\"$todayday\">$todayday</option>\n";
foreach ($days as $key => $value) {
	echo "<option value=\"$value\">$value</option>\n";
}
echo '</select>&nbsp;&nbsp;';
echo '<select name="' .$fieldname . '_month">';
//assumes datestuff.php
if ( $currymd )
	{
	echo "<option value=\"$currmm\">$currmm</option>\n";
	}
	echo "<option value=\"$thismonthno\">$thismonth</option>\n";
foreach ($months as $key => $value) {
	echo "<option value=\"$key\">$value</option>\n";
}
echo '</select>&nbsp;&nbsp;';
echo '<select name="' .$fieldname . '_year">';
	if ( $currymd )
	{
	echo "<option value=\"$curryyyy\">$curryyyy</option>\n";
	}
	echo "<option value=\"$thisyear\">$thisyear</option>\n";
foreach ($years as $key => $value) {
	echo "<option value=\"$key\">$value</option>\n";
}
echo '</select>';

?>