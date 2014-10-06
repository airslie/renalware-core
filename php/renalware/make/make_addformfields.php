<?php
//----Thu 13 Dec 2012----enhanced date handling: today v blank
//----Wed 08 Aug 2012----
foreach ($formfields as $fld => $specs) {
	$fldlbl=$formmap["$fld"];
	$fldval = (${$fld}) ? ${$fld} : "" ;
	list($fldtype,$specsnotes)=explode("^",$specs);
    list($fldspecs,$fldnotes)=explode("|",$specsnotes);
	//----Fri 20 Apr 2012----fldspecs-->bootstrap "spanX" 1 to 4
	echo '<div class="control-group">
    <label class="control-label" for="'.$fld.'">'.$fldlbl.'</label>
    <div class="controls">';
	switch ($fldtype) {
		case 't':
			echo '<input type="text" name="'.$fld.'" id="'.$fld.'" value="" class="span'.$fldspecs.'" autocomplete="off">';
			break;
		case 'd':
            $dateval = ($specsnotes=="today") ? date("d/m/Y") : '' ;
			echo '<input type="text" name="'.$fld.'" id="'.$fld.'" value="'.$dateval.'" class="span2 datepicker"><span class="help-inline red">d/m/Y</span>';
			break;
		case 'a':
			echo '<textarea class="span19" rows="'.$fldspecs.'" name="'.$fld.'" id="'.$fld.'">'.$fldval.'</textarea>';
			break;
		case 's':
			echo '<select name="'.$fld.'" id="'.$fld.'">';
				echo '<option value="">Select '.$fldlbl.'...</option>';
				echo ${$fldspecs};
			echo '</select>';
			break;
	}
	if ($fldnotes) {
		echo "<span class=\"help-inline red\">$fldnotes</span>";
	}
    echo '</div>
    </div>';
}
