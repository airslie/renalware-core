<?php
//----Sat 25 Aug 2012----tbs horiz
//----Wed 08 Aug 2012----IMPORTANT bootstrap datepicker depr pro tem
foreach ($formfields as $fld => $specs) {
	$fldlbl=$formmap["$fld"];
	$fldval = (${$fld}) ? ${$fld} : "" ;
	if ($specs=="d" or $specs=="f") {
		//$fldtype = ($specs=="d") ? 'date' : 'futuredate' ;
		$fldtype = 'date' ;
	} else {
		list($fldtype,$fldspecs)=explode("^",$specs);
	}
	echo '<div class="control-group">
        <label class="control-label" for="'.$fld.'">'.$fldlbl.'</label>
    <div class="controls">';
	switch ($fldtype) {
		case 't':
			echo '<input type="text" name="'.$fld.'" id="'.$fld.'" value="'.$fldval.'" class="span'.$fldspecs.'" autocomplete="off">';
			break;
		case 'date':
        //----Wed 08 Aug 2012----DEPR pro tem as problems with default date and ?how delete value
			echo '<input type="text" name="'.$fld.'" id="'.$fld.'" value="'.$fldval.'" class="span2"><span class="help-inline red">d/m/Y</span>';
			break;
		case 'a':
			echo '<textarea class="span9" rows="'.$fldspecs.'" name="'.$fld.'" id="'.$fld.'">'.$fldval.'</textarea>';
			break;
		case 's':
			echo '<select name="'.$fld.'" id="'.$fld.'" >';
			if (isset($fldval)) {
                $fldlbl=$fldval;
                if (substr($fld,-5)=="privs") {
                    $fldlbl = ($fldval==1) ? "Yes" : "No" ;
                }
				echo '<option value="'.$fldval.'">'.$fldlbl.'</option>';
			} else {
				echo '<option value="">Select...</option>';
			}
			echo ${$fldspecs};
			echo '</select>';
			break;
        }
    echo '</div>
</div>';
}
