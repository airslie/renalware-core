<?php
//----Thu 24 Feb 2011----
foreach ($datamap as $fld => $specslabel) {
	list($fldspecs,$fldlbl)=explode("^",$specslabel);
	$fldtype=substr($fldspecs,0,1);
	$fldval=${$fld};
	switch ($fldtype) {
		case 'x':
			$fldinput=$fldval; //display only, no update
			break;
		case 't':
			$fldsize=substr($fldspecs,1);
			$fldinput='<input type="text" class="txt" name="'.$fld.'" value="'.$fldval.'" size="'.$fldsize.'" />';
			break;
		case 'a':
		//e.g. a4x60^some field label
			list($rows,$cols)=explode("x",substr($fldspecs,1));
			$areawidth=10*$cols;
			$areaheight=10*$rows;
			$fldinput='<textarea name="'.$fld.'" id="'.$fld.'" style="width:'.$areawidth.'px; height: '.$areaheight.'px;">'.$fldval.'</textarea>';
			break;
		case 'd':
			$showdate = ($fldval) ? $fldval : date("d/m/Y"); ;
			$fldinput='<input type="text" name="'.$fld.'" value="'.$showdate.'" id="'.$fld.'" size="12" class="datepicker" />';
			break;
		case 'c':
		$fldinput='<input type="text" name="'.$fld.'" size="12" value="'.$fldval.'" class="datepicker" id="'.$fld.'" />';
			break;
		case 's':
			$fldinput='<select name="'.$fld.'" id="'.$fld.'">';
			if ($fldval) {
			    $fldval=$fldval;
				//get value/label from array
				$optionsarray=${$fld."array"};
				$optionval=$fldval;
				$optionlabel=($optionsarray[$fldval])? $optionsarray[$fldval] : $fldval ;
				$fldinput.='<option value="'.$optionval.'">'.$optionlabel.'</option>';
			} else {
				$fldinput.='<option value="">Select...</option>';
			}
			//finish optionlist w/ vals from array
			$fldoptions=${$fld ."_options"};
			$fldinput.=$fldoptions;
			$fldinput.= '</select>';
			break;
		case 'r':
			$fldinput='';
				$optionsarray=${$fld."array"};
				$optionval=$fldval;
				foreach ($optionsarray as $option) {
						$checkedflag = ($optionval==$option) ? " checked" : "" ;
						$fldinput.='<input type="radio" name="'.$fld.'" value="'.$option.'"'.$checkedflag.'> '.$option.'&nbsp;&nbsp;';
				}
			break;
		case 'f':
		$flagitems=array(
			'N'=>'No',
			'Y'=>'Yes');
			//use default from e.g. f0^ or f1^
			$fldinput='<select name="'.$fld.'" id="'.$fld.'">';
			$fldinput.='<option value="'.$fldval.'">'.$flagitems[$fldval].'</option>';
			$fldinput.='<option value="N">No</option><option value="Y">Yes</option><option value="">Unknown</option></select>';		
			break;
	} //switch
		echo "<li><label>$fldlbl</label>$fldinput</li>";
} //foreach
?>