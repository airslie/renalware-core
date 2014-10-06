<?php
//Mon Mar 31 11:19:35 GST 2008
//li added Fri May  8 14:40:12 CEST 2009
function labelSpecial($fieldname, $label, $specialtext)
	{
	echo '<li><label for="'.$fieldname.'">'.$label.'</label>&nbsp;&nbsp;'.$specialtext.'</li>';	
	}
//the following include any existing $vals...
function inputText($fieldname, $label, $size, $fieldvalue)
	{
	echo '<li><label for="'.$fieldname.'">'.$label.'</label>&nbsp;&nbsp;<input type="text" id="'.$fieldname.'" name="'.$fieldname.'" size="'.$size.'" value="'.$fieldvalue.'" /></li>';	
	}
function pickDate($fieldname, $label)
	{
	echo '<li><label for="'.$fieldname.'">'.$label.'</label>&nbsp;&nbsp;<input type="text" id="'.$fieldname.'" name="'.$fieldname.'" size="12" class="datepicker" /></li>';	
	}
function pickupDate($fieldname, $label, $defaultdate)
	{
	echo '<li><label for="'.$fieldname.'">'.$label.'</label>&nbsp;&nbsp;<input type="text" id="'.$fieldname.'" name="'.$fieldname.'" value="'.$defaultdate.'" size="12" class="datepicker" /></li>';	
	}
function picklabelDate($fieldname, $label)
	{
	echo '<input type="text" id="'.$fieldname.'" name="'.$fieldname.'" size="12" class="datepicker" title="'.$label.'" />';	
	}

function inputTextarea($fieldname, $label, $norows, $nocols, $fieldvalue)
	{
	echo '<li><label for="'.$fieldname.'">'.$label.'</label><br>
	<textarea id="'.$fieldname.'" name="'.$fieldname.'" rows="'.$norows.'" cols="'.$nocols.'">'.$fieldvalue.'</textarea></li>';	
	}
function makeSelect($fieldname, $label, $fieldvalue, $choicearray)
	{
	echo '<li><label for="'.$fieldname.'">'.$label.'</label>&nbsp;&nbsp;<select id="'.$fieldname.'" name="'.$fieldname.'">';	
	$firstoption = ($fieldvalue!='') ? '<option value="'.$fieldvalue.'">'.$choicearray[$fieldvalue].'</option>' : '<option value="">Select...</option>' ;
	echo "$firstoption\r";
	foreach ($choicearray as $key => $fieldvalue) {
		echo '<option value="'.$key.'">' . $fieldvalue . '</option>';
	}
	echo "</select></li>\r";
	}

function makeRadios($fieldname, $label, $fieldvalue, $radioarray)
	{
	echo '<li><label>'.$label.'</label>&nbsp;&nbsp;';
	$radiono=1;
	foreach ($radioarray as $radiovalue => $radiolabel) {
		$checked = ($fieldvalue==$radiovalue) ? 'checked="checked"' : '';
		echo '<input type="radio" name="'.$fieldname.'" id="'.$fieldname . '_'.$radiono.'" value="'.$radiovalue.'" '.$checked.' /><b>'.$radiolabel.'</b>&nbsp;&nbsp;';
		$radiono++;
	}
	echo "</li>\r";
	}
function makeRange($fieldname, $label, $fieldvalue, $range)
	{
	echo '<li><label>'.$label.'</label>&nbsp;&nbsp;';
	$radiono=1;
	foreach ($range as $key => $rangeno) {
		$checked = ($fieldvalue==$rangeno) ? 'checked="checked"' : '';
		echo '<input type="radio" name="'.$fieldname.'" id="'.$fieldname . '_'.$radiono.'" value="'.$rangeno.'" '.$checked.' /><b>'.$rangeno.'</b>&nbsp;&nbsp;';
		$radiono++;
	}
	echo "</li>\r";
	}

function makeCheckboxes($fieldname, $label, $fieldvalue, $checkboxarray)
	{
	echo '<li><label>'.$label.'</label>&nbsp;&nbsp;';
	$checkboxno=1;
	foreach ($checkboxarray as $checkboxvalue => $checkboxlabel) {
		$checked = ($fieldvalue==$checkboxvalue) ? 'checked="checked"' : '';
		echo '<input type="checkbox" name="'.$fieldname.'" id="'.$fieldname . '_'.$checkboxno.'" value="'.$checkboxvalue.'" '.$checked.' /><label for="'.$fieldname . '_'.$checkboxno.'">'.$checkboxlabel.'</label>&nbsp;&nbsp;';
		$checkboxno++;
	}
	echo "</li>\r";
	}
//---------------------------
//the following DO NOT include any existing $vals...
function inputnewText($fieldname, $label, $size)
	{
	echo '<li><label for="'.$fieldname.'">'.$label.'</label>&nbsp;&nbsp;<input type="text" id="'.$fieldname.'" name="'.$fieldname.'" size="'.$size.'" value="" /></li>';	
	}

function inputnewTextarea($fieldname, $label, $norows, $nocols)
	{
	echo '<li><label for="'.$fieldname.'">'.$label.'</label><br>
	<textarea id="'.$fieldname.'" name="'.$fieldname.'" rows="'.$norows.'" cols="'.$nocols.'"></textarea></li>';	
	}
function makenewSelectKey($fieldname, $label, $choicearray)
	{
	echo '<li><label for="'.$fieldname.'">'.$label.'</label>&nbsp;&nbsp;<select id="'.$fieldname.'" name="'.$fieldname.'">';	
	$firstoption = '<option value="">Select...</option>' ;
	echo "$firstoption\r";
	foreach ($choicearray as $key => $optionval) {
		echo '<option value="'.$optionval.'">' . $optionval . '</option>';
	}
	echo "</select></li>\r";
	}
function makenewSelectVal($fieldname, $label, $choicearray)
	{
	echo '<li><label for="'.$fieldname.'">'.$label.'</label>&nbsp;&nbsp;<select id="'.$fieldname.'" name="'.$fieldname.'">';	
	$firstoption = '<option value="">Select...</option>' ;
	echo "$firstoption\r";
	foreach ($choicearray as $optionval => $optionlabel) {
		echo '<option value="'.$optionval.'">' . $optionlabel . '</option>';
	}
	echo "</select></li>\r";
	}

function makenewRadios($fieldname, $label, $radioarray)
	{
	echo '<li><label>'.$label.'</label>&nbsp;&nbsp;';
	$radiono=1;
	foreach ($radioarray as $radiovalue => $radiolabel) {
		echo '<input type="radio" name="'.$fieldname.'" id="'.$fieldname . '_'.$radiono.'" value="'.$radiovalue.'" /><li><label for="'.$fieldname . '_'.$radiono.'">'.$radiolabel.'</label>&nbsp;&nbsp;';
		$radiono++;
	}
	echo "</li>\r";
	}
function makenewRange($fieldname, $label, $range)
	{
	echo '<li><label>'.$label.'</label>&nbsp;&nbsp;';
	$radiono=1;
	foreach ($range as $key => $rangeno) {
		echo '<input type="radio" name="'.$fieldname.'" id="'.$fieldname . '_'.$radiono.'" value="'.$rangeno.'" /><li><label for="'.$fieldname . '_'.$radiono.'">'.$rangeno.'</label>&nbsp;&nbsp;';
		$radiono++;
	}
	echo "</li>\r";
	}

function makenewCheckboxes($fieldname, $label, $checkboxarray)
	{
	echo '<li><label>'.$label.'</label>&nbsp;&nbsp;';
	$checkboxno=1;
	foreach ($checkboxarray as $checkboxvalue => $checkboxlabel) {
		echo '<input type="checkbox" name="'.$fieldname.'" id="'.$fieldname . '_'.$checkboxno.'" value="'.$checkboxvalue.'" /><li><label for="'.$fieldname . '_'.$checkboxno.'">'.$checkboxlabel.'</label>&nbsp;&nbsp;';
		$checkboxno++;
	}
	echo "</li>\r";
	}

//miscell
$yesno = array(
	"Y"=>'Yes',
	"N"=>'No',
	);

function makeRadioItems($radiofld, $currvalue, $radioitems)
{
	foreach ($radioitems as $key => $value) {
		$checked = ($currvalue==$value) ? 'checked="checked"' : '' ;
		echo '<input type="radio" name="'.$radiofld.'" value="'.$value.'" '.$checked.' />'.$value.' &nbsp;&nbsp;';
	}
}
?>