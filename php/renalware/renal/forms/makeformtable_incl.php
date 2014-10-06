<?php
//----Tue 15 Jun 2010----
foreach ($form_data as $key => $value) {
	$fld_type=explode(".",$key);
	$fldname=$fld_type[0];
	$fldtype=substr($fld_type[1],0,1);
	$fldlabel=$value;
	//see if filled
	$fldvalue=${$fldname}?${$fldname}:FALSE;
	echo '<li><label for="'.$fldname.'">'.$fldlabel.'</label>&nbsp;&nbsp;';
	switch ($fldtype) {
		case 't':
			$fldsize=substr($fld_type[1],1);
			$showvalue=$fldvalue?$fldvalue:"";
			echo '<input type="text" name="'.$fldname.'" id="'.$fldname.'" size="'.$fldsize.'" value="'.$showvalue.'" />';
			break;
		case 'd':
			echo '<input type="text" class="datepicker" name="'.$fldname.'" id="'.$fldname.'" size="12" value="'.$fldvalue.'" />';
			break;
		case 'a':
			$rows_cols=explode('x', substr($fld_type[1],1));
			$rows=$rows_cols[0];
			$cols=$rows_cols[1];
			$showtext=$fldvalue?$fldvalue:"";
			echo '<textarea name="'.$fldname.'" rows="'.$rows.'" cols="'.$cols.'">'.$showtext.'</textarea>';
			break;
		case '1':
			$checkstatus=$fldvalue==1?"checked=\"checked\"":"";
			echo '<input type="checkbox" name="'.$fldname.'" id="'.$fldname.'" value="1" '.$checkstatus.'/>Yes';
			break;
		case 'y':
			$checkstatus=$fldvalue=="Y"?"checked=\"checked\"":"";
			echo '<input type="checkbox" name="'.$fldname.'" id="'.$fldname.'" value="Y" '.$checkstatus.'/>Yes';
			break;
		case 'n':
			$ystatus=$fldvalue=="Y"?"checked=\"checked\"":"";
			$nstatus=$fldvalue=="N"?"checked=\"checked\"":"";
			echo '<input type="checkbox" name="'.$fldname.'" id="'.$fldname.'" value="Y" '.$ystatus.'/>Yes&nbsp;&nbsp;<input type="checkbox" name="'.$fldname.'" id="'.$fldname.'" value="N" '.$nstatus.'/>No';
			break;
		case 's':
		$options=${$fldname ."_options"};
			echo '<select name="'.$fldname.'" id="'.$fldname.'">';
			echo $fldvalue?"<option value=\"$fldvalue\">$fldvalue</option>":"<option value=\"\">Select...</option>";
			foreach ($options as $key => $value) {
				echo "<option>$value</option>\n";
			}
			echo '</select>';
			break;
		case 'o':
		//----Wed 16 Nov 2011----uses optionlists tbl for listhtml
		$thisoptionlist=${$fldname ."_optionlist"};
			echo '<select name="'.$fldname.'" id="'.$fldname.'">';
			echo $fldvalue?"<option value=\"$fldvalue\">$fldvalue</option>":"<option value=\"\">Select...</option>";
			echo $thisoptionlist;
			echo '</select>';
			break;
		case 'r':
		$radioitems=${$fldname ."_options"};
			foreach ($radioitems as $key => $value) {
				$checkstatus=$fldvalue==$value?"checked=\"checked\"":"";
				echo '<input type="radio" name="'.$fldname.'" value="'.$value.'" '.$checkstatus.' /> '.$value.' &nbsp; &nbsp;';
			}
			break;
		}
	echo "</li>\n";
	}
?>