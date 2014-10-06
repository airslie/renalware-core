<?php
//Thu Nov 20 12:58:09 GMT 2008 for HL7
include realpath($_SERVER['DOCUMENT_ROOT'].'/').'../../tmp/renalwareconn.php';
$sql = "SELECT * FROM hl7patientdata WHERE kchno='$kchno' LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$lastname=$row["lastname"];
$firstname=$row["firstname"];
$birthdatedmy=dmy($row["birthdate"]);
$sex=$row["sex"];
$nhsno=$row["nhsno"];
$piddata=$row["piddata"];
$pd1data=$row["pd1data"];
$piddataarray=explode
//PID array
$pidarray=array(
	'Set ID',
	'NHS No',
	'KCH No',
	'Alternate Patient ID',
	'Patient Name',
	'Mothers Maiden Name',
	'BirthDateTime',
	'Sex',
	'Patient Alias',
	'Race',
	'Patient Address',
	'County Code',
	'Phone Number-Home',
	'Phone Number-Business',
	'Primary Language',
	'Marital Status',
	'Religion',
	'Patient Account Number',
	'SSN Number-Patient',
	'Drivers License Number-Patient',
	'Mothers Identifier',
	'Ethnic Group',
	'Birth Place',
	'Multiple Birth Indicator',
	'Birth Order',
	'Citizenship',
	'Veterans Military Status',
	'Nationality',
	'Patient Death DateTime',
	'Patient Death Indicator',
	);
$displayfields=array(
	'NHS No',
	'KCH No',
	'Patient Name',	'Mothers Maiden Name',
	'BirthDateTime',
	'Sex',
	'Race',
	'Patient Address',
	'County Code',
	'Phone Number-Home',
	'Phone Number-Business',
	'Primary Language',
	'Marital Status',
	'Religion',
	'Ethnic Group',
	'Nationality',
	'Patient Death DateTime',
	'Patient Death Indicator',
	);
?>
<form action="pat/run/add_patient.php" method="post">
<fieldset>
	<legend>Add Patient Hospital No(s)</legend>
	<ul class="form">
	<li><label for="patsite">Patient Site</label>&nbsp;<input type="radio" name="patsite" value="KCH" checked="checked" />KCH &nbsp; &nbsp; <input type="radio" name="patsite" value="QEH" />QEH  &nbsp; &nbsp; <input type="radio" name="patsite" value="DVH" />DVH
		&nbsp; &nbsp; <input type="radio" name="patsite" value="BROM" />Bromley
		&nbsp; &nbsp; <input type="radio" name="patsite" value="GUYS" />Guy&rsquo;s</li>
<?php
inputnewText("hospno1","$hosp1label",12);
inputnewText("hospno2","$hosp2label",12);
inputnewText("hospno3","$hosp3label",12);
inputnewText("hospno4","$hosp4label",12);
inputnewText("hospno5","$hosp5label",12);
inputnewText("nhsno","NHS No",12);
?>
</ul>
</fieldset>
<fieldset>
	<legend>Patient Name &amp; Demographics</legend>
	<ul>
<li><label for="title">Title</label>&nbsp;<select id="title" name="title">
	<option>Mr</option>
	<option>Ms</option>
	<option>Mrs</option>
	<option>Miss</option>
	<option>Dr</option>
	<option>Prof</option>
	</select></li>
<?php
inputnewText("lastname","last name",50);
inputnewText("firstnames","first names",50);
inputnewText("suffix","suffix (e.g. Jr, Sr)",10);

?>
<li><label for="sex">sex</label>&nbsp;<select id="sex" name="sex">
	<option value="M">Male</option>
	<option value="F">Female</option>
</select></li>
<li><label for="dob_day">DOB</label>&nbsp;<select id="dob_day" name="dob_day">
		<?php
		$fieldname="birthdate";
		$months = array (1 => 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
		$days = range(1, 31);
		$years = range(1907, 2008);
		//
		foreach ($days as $key => $value) {
			$dd=str_pad($value, 2, "0", STR_PAD_LEFT);
			echo "<option value=\"$dd\">$value</option>\n";
		}
		?>
		</select>&nbsp;
		&nbsp;<select id="dob_month" name="dob_month">
		<?php
		foreach ($months as $key => $value) {
			$mm=str_pad($key, 2, "0", STR_PAD_LEFT);
			echo "<option value=\"$mm\">$mm -- $value</option>\n";
		}
		?>
		</select>&nbsp;
		<select id="dob_year" name="dob_year">
		<?php
		foreach ($years as $key => $value) {
			echo "<option value=\"$value\">$value</option>\n";
		}
		?>
		</select></li>
<li><label for="maritstatus">marit status</label>&nbsp;<select id="maritstatus" name="maritstatus">
	<option>Unknown</option>
	<option>Married</option>
	<option>Single</option>
	<option>Divorced</option>
	<option>Widowed</option>
	</select></li>
<li><label for="ethnicity">ethnicity</label>&nbsp;<select id="ethnicity" name="ethnicity"><?php include( '../optionlists/ethnicities.html' ); ?></select></li>
<li><label for="religion">religion</label>&nbsp;<select id="religion" name="religion"><?php include( '../optionlists/religions.html' ); ?></select></li>
<li><label for="language">language</label>&nbsp;<select id="language" name="language"><?php include( '../optionlists/languages.html' ); ?></select></li>
<li><label for="interpreter">interpreter</label>&nbsp;<input type="text" id="interpreter" name="interpreter" size ="20" /></li>
<li><label for="specialneeds">special needs</label>&nbsp;<input type="text" id="specialneeds" name="specialneeds" size ="20" /></li>
</ul>
</fieldset>
<fieldset>
	<legend>Patient Address &amp; Contact Info</legend>
	<ul class="form">
<li><label for="addr1">addr1</label>&nbsp;<input type="text" id="addr1" name="addr1" size ="30" /></li>
<li><label for="addr2">addr2</label>&nbsp;<input type="text" id="addr2" name="addr2" size ="30" /></li>
<li><label for="addr3">addr3</label>&nbsp;<input type="text" id="addr3" name="addr3" size ="30" /></li>
<li><label for="addr4">addr4</label>&nbsp;<input type="text" id="addr4" name="addr4" size ="30" /></li>
<li><label for="postcode">postcode</label>&nbsp;<input type="text" id="postcode" name="postcode" size ="30" /></li>
<li><label for="tel1">tel1</label>&nbsp;<input type="text" id="tel1" name="tel1" size ="30" /></li>
<li><label for="tel2">tel2</label>&nbsp;<input type="text" id="tel2" name="tel2" size ="30" /></li>
<li><label for="fax">fax</label>&nbsp;<input type="text" id="fax" name="fax" size ="30" /></li>
<li><label for="mobile">mobile</label>&nbsp;<input type="text" id="mobile" name="mobile" size ="30" /></li>
<li><label for="email">email</label>&nbsp;<input type="text" id="email" name="email" size ="30" /></li>
<li><label for="tempaddr">temp address</label>&nbsp;<input type="text" id="tempaddr" name="tempaddr" size ="50" /></li>
</ul>
</fieldset>
<fieldset>
	<legend>Patient Options/Notes/CCs</legend>
	<ul class="form">
<li><label for="ccflag">CC letters?</label>&nbsp;<select id="ccflag" name="ccflag">
	<option value="Y">Yes</option>
	<option value="N">No</option>
</select></li>
<li><label for="ccflagdate">CC date asked</label>&nbsp;<input type="text" id="ccflagdate" name="ccflagdate" size="14" value="<?php echo date("d/m/Y") ?>" /></li>
<li><label for="adminnotes">Patient/Admin Notes</label><br>
<textarea name="adminnotes" rows="5" cols="60"></textarea></li>
<li><label for="defaultccs">Default CCs</label><br>
<textarea name="defaultccs" rows="10" cols="60"></textarea></li>
</ul>
</fieldset>
<fieldset>
	<legend>Next of Kin Info</legend>
	<ul class="form">
<li><label for="nok_name">NOK name</label>&nbsp;<input type="text" id="nok_name" name="nok_name" size ="30" /></li>
<li><label for="nok_addr1">NOK addr1</label>&nbsp;<input type="text" id="nok_addr1" name="nok_addr1" size ="30" /></li>
<li><label for="nok_addr2">NOK addr2</label>&nbsp;<input type="text" id="nok_addr2" name="nok_addr2" size ="30" /></li>
<li><label for="nok_addr3">NOK addr3</label>&nbsp;<input type="text" id="nok_addr3" name="nok_addr3" size ="30" /></li>
<li><label for="nok_addr4">NOK addr4</label>&nbsp;<input type="text" id="nok_addr4" name="nok_addr4" size ="30" /></li>
<li><label for="nok_postcode">NOK postcode</label>&nbsp;<input type="text" id="nok_postcode" name="nok_postcode" size ="30" /></li>
<li><label for="nok_tels">NOK tels</label>&nbsp;<input type="text" id="nok_tels" name="nok_tels" size ="30" /></li>
<li><label for="nok_email">NOK email</label>&nbsp;<input type="text" id="nok_email" name="nok_email" size ="30" /></li>
<li><label for="nok_notes">NOK notes</label>&nbsp;<input type="text" id="nok_notes" name="nok_notes" size ="50" /></li>
</ul>
</fieldset>
<fieldset>
	<legend>GP &amp; Referral Info</legend>
	<ul class="form">
<li><label for="gp_name">GP name</label>&nbsp;<input type="text" size="30" id="gp_name" name="gp_name" ></li>
<li><label for="gp_addr1">gp_addr1</label>&nbsp;<input type="text" size="30" id="gp_addr1" name="gp_addr1" ></li>
<li><label for="gp_addr2">gp_addr2</label>&nbsp;<input type="text" size="30" id="gp_addr2" name="gp_addr2" ></li>
<li><label for="gp_addr3">gp_addr3</label>&nbsp;<input type="text" size="30" id="gp_addr3" name="gp_addr3" ></li>
<li><label for="gp_addr4">gp_addr4</label>&nbsp;<input type="text" size="30" id="gp_addr4" name="gp_addr4" ></li>
<li><label for="gp_postcode">gp_postcode</label>&nbsp;<input type="text" size="30" id="gp_postcode" name="gp_postcode" ></li>
<li><label for="gp_tel">gp_tel</label>&nbsp;<input type="text" size="30" id="gp_tel" name="gp_tel" ></li>
<li><label for="gp_fax">gp_fax</label>&nbsp;<input type="text" size="30" id="gp_fax" name="gp_fax" ></li>
<li><label for="gp_email">gp_email</label>&nbsp;<input type="text" size="30" id="gp_email" name="gp_email" ></li>
<li><label for="referrer">REFERRED BY</label>&nbsp;<input type="text" id="referrer" name="referrer" size ="50" /></li>
<li><label for="refer_date">referral date</label>&nbsp;<input type="text" id="refer_date" name="refer_date" size ="12" /></li>
<li><label for="refer_type">referral type</label>&nbsp;<input type="text" id="refer_type" name="refer_type" size ="50" /></li>
<li><label for="refer_notes">referral notes</label>&nbsp;<input type="text" id="refer_notes" name="refer_notes" size ="50" /></li>
<li class="submit"><input type="submit" style="color: green;" value="add patient" /></li>
</ul>
</fieldset>
</form>