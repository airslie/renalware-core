<?php
foreach ($basket as $key => $value) {
	$size=20; //def
	$fielddata=explode('*',$key);
	$type=$fielddata[0];
	$field=$fielddata[1];
	$fieldvalue=$row[$field];
	if ($type=='d') {
		$size=12;
		$fieldvalue=dmyyyy($fieldvalue);
	}
	$labelinput= "<p><label for=\"$field\">$value</label><input type=\"text\" id=\"$field\" value=\"$fieldvalue\" size=\"$size\" /></p>\n";
	if ($type=="p") {
	$labelinput= "<p><label for=\"$field\">$value</label><select name=\"$field\">$fieldvalue</option>\n$posneg</select></p>\n";
	}
	echo $labelinput;
}
?>