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
	$labeldata= "<p><label for=\"$field\">$value</label> <span class=\"data\">$fieldvalue</p>\n";
	echo $labeldata;
}
?>