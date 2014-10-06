<?php
echo "<label class=\"css\">$fldlabel</label>&nbsp;&nbsp;";
//for radio id
$radiono=1;
foreach ($radios as $key => $value) {
	$checked = (${$fldname}=="$value") ? 'checked="checked"' : '';
	echo '<input type="radio" name="'.$fldname.'" id="'.$fldname . '_'.$radiono.'" value="'.$value.'" '.$checked.' /><label for="'.$fldname . '_'.$radiono.'">'.$value.'</label>&nbsp;&nbsp;';
	$radiono++;
}
echo "<br>";
?>