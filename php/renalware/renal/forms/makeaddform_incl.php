<?php
//
foreach ($form_data as $fldname => $fldtypedata) {
	$fldlabel=$form_map[$fldname];
	$fldtype=substr($fldtypedata,0,1);
	//see if filled
	echo '<tr><td><label for='.$fldname.'>'.$fldlabel.'</label></td><td>';
	switch ($fldtype) {
		case 't':
			$fldsize=substr($fldtypedata,1);
			echo '<input type="text" name="'.$fldname.'" id="'.$fldname.'" size="'.$fldsize.'" value="" />';
			break;
		case 'd':
			echo '<input type="text" class="datepicker" name="'.$fldname.'" id="'.$fldname.'" size="12" value="'.date("d/m/Y") .'"/>';
			break;
		case 'a':
			$rows_cols=explode('x', substr($fldtypedata,1));
			$rows=$rows_cols[0];
			$cols=$rows_cols[1];
			echo '<textarea name="'.$fldname.'" rows="'.$rows.'" cols="'.$cols.'"></textarea>';
			break;
		case '1':
			echo '<input type="checkbox" name="'.$fldname.'" id="'.$fldname.'" value="1" '.$checkstatus.'/>Yes';
			break;
		case 'y':
			echo '<input type="checkbox" name="'.$fldname.'" id="'.$fldname.'" value="Y" '.$checkstatus.'/>Yes';
			break;
		case 'n':
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
		case 'r':
		$radioitems=${$fldname ."_options"};
			foreach ($radioitems as $key => $value) {
				$checkstatus=$fldvalue==$value?"checked=\"checked\"":"";
				echo '<input type="radio" name="'.$fldname.'" value="'.$value.'" '.$checkstatus.' /> '.$value.' &nbsp; &nbsp;';
			}
			break;
		}
	echo "</td></tr>\n";
	}
?>