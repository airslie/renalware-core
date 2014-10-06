<?php
//----Fri 23 May 2014----merge form here for simplicity (of sorts); KCH default site
//----Fri 28 Jun 2013----tidying
include '../req/confcheckfxns.php';
$pagetitle= "Add New $siteshort Consult Patient";
include "$rwarepath/navs/topsimplenav.php";
echo '<p class="alert">ENSURE THE PATIENT IS NOT ALREADY IN RENALWARE!</p>';
$showtoday=date("d/m/Y");
// ---------start form

echo '<form action="pat/run/run_addconsultpatient.php" method="post">
<fieldset>
	<legend>Add KCH Consult Patient Hosp No</legend>
	<ul class="form">
		<li><label for="consultsite">Consult Site REQUIRED</label>&nbsp;
		<select name="consultsite" id="consultsite">
			<option value="KCH">KCH (Default)</option>
			<option>QEH</option>
			<option>DVH</option>
			<option>BROM</option>
			<option>GUYS</option>
			<option>KCH</option>
			<option value="Other">Other--Specify below</option>
		</select></li>
	<li><label for="othersite">Other Site</label>&nbsp;<input type="text" id="othersite" name="othersite" size ="20" /></li>';
inputnewText("hospno1","$hosp1label",8);
echo '<li><label for="sitehospno">Site Hosp No (if not KCH)</label>&nbsp;<input type="text" id="sitehospno" name="sitehospno" size ="20" /></li>
</ul>
</fieldset>
<fieldset>
	<legend>Patient Name &amp; Demographics</legend>
	<ul class="form">
<li><label for="title">Title</label>&nbsp;<select id="title" name="title">';
    include "$rwarepath/optionlists/titleoptionlist.html";
echo '</select></li>';
inputnewText("lastname","last name",50);
inputnewText("firstnames","first names",50);
inputnewText("suffix","suffix (e.g. Jr, Sr)",10);
echo '<li><label for="sex">sex</label>&nbsp;<select id="sex" name="sex">
	<option value="M">Male</option>
	<option value="F">Female</option>
</select></li>
<li><label for="dob_day">DOB</label>&nbsp;<select id="dob_day" name="dob_day">';
		$fieldname="birthdate";
		$months = array (1 => 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
		$days = range(1, 31);
		$years = range(1907, 2008);
		//
		foreach ($days as $key => $value) {
			$dd=str_pad($value, 2, "0", STR_PAD_LEFT);
			echo "<option value=\"$dd\">$value</option>\n";
		}
echo '</select>&nbsp;
		&nbsp;<select id="dob_month" name="dob_month">';
		foreach ($months as $key => $value) {
			$mm=str_pad($key, 2, "0", STR_PAD_LEFT);
			echo "<option value=\"$mm\">$mm -- $value</option>\n";
		}
echo '</select>&nbsp;
		<select id="dob_year" name="dob_year">';
		foreach ($years as $key => $value) {
			echo "<option value=\"$value\">$value</option>\n";
		}
echo '</select></li>
</ul>
</fieldset>
<fieldset>
	<legend>Patient Notes</legend>
	<ul class="form">
<li><label for="adminnotes">Special Notes re Consult</label><br>
<textarea name="adminnotes" rows="5" cols="60"></textarea></li>
</fieldset>
<fieldset>
	<legend>Consult Referral Info ***REQUIRED***</legend>
	<ul class="form">
<li><label for="referrer">REFERRED BY</label>&nbsp;<input type="text" id="referrer" name="referrer" size ="50" /></li>
<li><label for="selectward">KCH Ward</label>&nbsp;
<select name="selectward" id="selectward">
	<option value="">Select KCH Ward...</option>';
    include "$rwarepath/optionlists/consultwardoptionlist.html";
echo '</select></li>
<li><label for="otherward">Other/Non-KCH Ward</label>&nbsp;<input type="text" id="otherward" name="otherward" size ="20" /></li>
<li><label for="contactbleep">Contact/Bleep Info</label>&nbsp;<input type="text" id="contactbleep" name="contactbleep" size ="20" /></li>
<li><label for="consulttype">Type (e.g. Cardiol)</label>&nbsp;<input type="text" id="consulttype" name="consulttype" size ="20" /></li>
<li><label for="consultstartdate">consult date</label>&nbsp;<input type="text" id="consultstartdate" name="consultstartdate" value="'.$showtoday.'" size ="12" /></li>
<li><label for="consultstaffname">Seen by</label>&nbsp;<input type="text" id="consultstaffname" name="consultstaffname" value="'.$user.'" size ="20" /></li>
<li><label for="consultdescr">consult description</label>&nbsp;<textarea name="consultdescr" id="consultdescr" rows="4" cols="100"></textarea></li>
<li><label for="akiriskflag">AKI Risk (non-ESRF)?</label>&nbsp;<select name="akiriskflag" id="akiriskflag">
	<option value="">Select Y/N/Unknown...</option>
	<option value="Y">Yes (an AKI Episode will be created)</option>
	<option value="N">No</option>
	<option value="U">Unknown</option>
</select></li>
<li class="submit"><input type="submit" class="btn btn-small btn-success" value="add new consult patient" /></li>
</ul>
</fieldset>
</form>';






// ----------end form




include '..parts/footer.php';
