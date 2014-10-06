<?php
//--Sat Dec 28 14:36:59 EST 2013--
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
			$fldinput='<input type="text" name="'.$fld.'" value="'.$fldval.'" size="'.$fldsize.'" />';
            $formgroupflag=true;
			break;
            
		case 'a':
		//e.g. a4x60^some field label
			list($rows,$cols)=explode("x",substr($fldspecs,1));
			$fldinput='<textarea name="'.$fld.'" id="'.$fld.'" class="form-control" rows="'.$rows.'">'.$fldval.'</textarea>';
            $formgroupflag=true;
			break;
		case 'd':
			$showdate = ($fldval) ? $fldval : date("d/m/Y"); ;
			$fldinput='<input type="date" name="'.$fld.'" value="'.$showdate.'" id="'.$fld.'" class="form-control" />';
            $formgroupflag=true;
			break;
		case 'c':
		$fldinput='<input type="text" name="'.$fld.'" value="'.$fldval.'" class="form-control datepicker" id="'.$fld.'" />';
        $formgroupflag=true;
			break;
		case 's':
			$fldinput='<select class="form-control" name="'.$fld.'" id="'.$fld.'">';
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
            $formgroupflag=true;
			break;
		case 'r':
			$fldinput='';
				$optionsarray=${$fld."array"};
				$optionval=$fldval;
				foreach ($optionsarray as $option) {
						$checked = ($optionval==$option) ? " checked" : "" ;
                        echo '<div class="radio">
  <label>
    <input type="radio" name="'.$fld.'" value="'.$option.'" '.$checked.'>'.$option.'
  </label>
</div>';
				}
			break;
		case 'f':
		$flagitems=array(
			'N'=>'No',
			'Y'=>'Yes',
			'U'=>'Unknown'
		);
			//use default from e.g. f0^ or f1^
			$fldinput='<select name="'.$fld.'" id="'.$fld.'">';
			$fldinput.='<option value="'.$fldval.'">'.$flagitems[$fldval].'</option>';
			$fldinput.='<option value="N">No</option><option value="Y">Yes</option><option value="U">Unknown</option></select>';		
			break;
		case 'n':
        //----Tue 05 Mar 2013----for numeric Y/N values e.g. AKI scores
		$flagitems=array(
			'0'=>'No',
			'1'=>'Yes',
		);
			//use default from e.g. f0^ or f1^
			$fldinput='<select name="'.$fld.'" id="'.$fld.'">';
            if ($fldval) {
    			$fldinput.='<option value="'.$fldval.'">'.$flagitems[$fldval].'</option>';
            } else {
    			$fldinput.='<option value="">Select...</option>';
            }
			$fldinput.='<option value="0">No</option><option value="1">Yes</option></select>';
            $formgroupflag=true;
			break;
	} //switch
	if ($formgroupflag) {
        echo '<div class="form-group">
    <label for="'.$fld.'" class="col-sm-2 control-label">'.$fldlbl.'</label>
    <div class="col-sm-6">'.$fldinput.'
    </div>
  </div>';
	}
} //foreach
