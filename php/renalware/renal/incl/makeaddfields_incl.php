<?php
//----Thu 24 Feb 2011----2012-03-12
foreach ($datamap as $fld => $specslabel) {
	list($fldspecs,$fldlbl)=explode("^",$specslabel);
	$fldtype=substr($fldspecs,0,1);
	//$fldval=${$fld};
	switch ($fldtype) {
		case 'x':
			$fldinput=$fldval; //display only, no update
			break;
		case 't':
			$fldsize=substr($fldspecs,1);
			$fldinput='<input type="text" class="txt" name="'.$fld.'" size="'.$fldsize.'" />';
			break;
		case 'a':
		//e.g. a4x60^some field label
			list($rows,$cols)=explode("x",substr($fldspecs,1));
			$areawidth=10*$cols;
			$areaheight=10*$rows;
			$fldinput='<textarea name="'.$fld.'" id="'.$fld.'" style="width:'.$areawidth.'px; height: '.$areaheight.'px;"></textarea>';
			break;
		case 'd':
			$showdate = date("d/m/Y");
			$fldinput='<input type="text" name="'.$fld.'" value="'.$showdate.'" id="'.$fld.'" size="12" class="datepicker" />';
			break;
		case 'c':
		$fldinput='<input type="text" name="'.$fld.'" size="12" class="datepicker" id="'.$fld.'" />';
			break;
		case 's':
			$fldinput='<select name="'.$fld.'" id="'.$fld.'">';
			$fldinput.='<option value="">Select...</option>';
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
					$fldinput.='<input type="radio" name="'.$fld.'" value="'.$option.'"> '.$option.'&nbsp;&nbsp;';
				}
			break;
			//----Fri 11 Mar 2011---- for POS-S
		case 'zr':
			$fldinput='';
				$optionsarray=$possnumoptionsarray;
				$optionval=$fldval;
				foreach ($optionsarray as $key => $value) {
					$fldinput.='<input type="radio" name="'.$fld.'" value="'.$key.'"> '.$value.' ('.$key.')&nbsp;&nbsp;';
				}
			break;
			case 'z':
			//2012-03-12 POSS selects
				$fldinput='<select name="'.$fld.'" id="'.$fld.'">
				<option value="">Select score...</option>
				<option value="0">0--Not at all</option>
				<option value="1">1--Slightly</option>
				<option value="2">2--Moderately</option>
				<option value="3">3--Severely</option>
				<option value="4">4--Overwhelmingly</option>
				</select>';
				break;
	
		case 'f':
		$flagitems=array(
			'N'=>'No',
			'Y'=>'Yes',
			'U'=>'Unknown'
		);
			//use default from e.g. f0^ or f1^
			$fldinput='<select name="'.$fld.'" id="'.$fld.'">';
			//$fldinput.='<option value="'.$fldval.'">'.$flagitems[$fldval].'</option>';
			$fldinput.='<option value="N">No</option><option value="Y">Yes</option><option value="U">Unknown</option></select>';		
			break;
	} //switch
	if ($fldtype!="x") {
		echo "<li><label>$fldlbl</label>$fldinput</li>";
	}
} //foreach
?>