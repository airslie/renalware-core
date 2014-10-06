<?php
//Sun May 10 17:13:35 CEST 2009
//
foreach ($form_data as $key => $value) {
	$fld_type=explode(".",$key);
	$fldname=$fld_type[0];
	$fldtype=substr($fld_type[1],0,1);
	$fldlabel=$value;
	//see if filled
	$fldvalue=${$fldname}?${$fldname}:"&nbsp;";
	echo '<li><b>'.$fldlabel.'</b>&nbsp;&nbsp;'.$fldvalue.'</li>';
	}
?>