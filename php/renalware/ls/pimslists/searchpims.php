<p class="alertsmall">Enter <b>either</b> KCH No <b>or</b> Patient surname and DOB (d/m/YYYY format). NOTE: Data are from c. Feb 2008.</p>
<form action="ls/pimslists.php" method="get" accept-charset="utf-8">
	<input type="hidden" name="vw" value="searchpims" id="vw" />
	<input type="hidden" name="search" value="pims" id="search" />
	<fieldset>
		<legend>Search by KCH No *OR* Surname and DOB</legend>
		<label for="kchno">KCH No</label><input type="text" name="kchno" size="7" id="kchno" /> <b>or</b> <label for="last_name">Last Name</label><input type="text" name="last_name" size="20" id="last_name" /> AND <label for="dob">DOB (d/m/yyyy)</label><input type="text" name="dob" size="12" id="dob" />
	</fieldset>
	<p><input type="submit" style="color: green;" value="Search &rarr;" /></p>
</form>
<?php
if ($_GET) {
	foreach ($_GET as $key => $value) {
		${$key}=$value;
		echo $key."=".${$key}."<br>";
	}
}

//-------SET FORM VARS--------
$thisvw="searchpims";
$displaytext = "PIMS patient matches"; //default
$fieldslist=array(
	'kchno'=>'KCH No',
	'lastname'=>'last name',
	'firstname'=>'first name',
	'middlename'=>'middle name',
	'birthdate'=>'DOB',
	'sex'=>'sex',
	'nhsno'=>'NHS No',
	'gp_id'=>'GP code',
	'gpname'=>'GP name',
	'practicename'=>'Practice',
	'pctcode'=>'PCT code',
	'pctname'=>'PCT',
	);
$thisportalname="PIMS Patients **BETA**";
$portalbase="pimslist.php?vw=searchpims";
$fields="";
$omitfields=array();
$th ="";
$flip = ($get_flip=="DESC") ? "ASC" : "DESC" ;
$orderby = ($specialorderby) ? $specialorderby : "ORDER BY lastname, firstname" ;
$sortedby=FALSE;
//order by sortfield prn
if ($get_sortlist) {
	$orderby= "ORDER BY $get_sortlist $flip";
	$sortedby="SORTED BY " . $fieldslist[$get_sortlist];
}
$dataheaders="";
foreach ($fieldslist as $key => $value) {
	$fields.=", $key";
	if (!in_array($key,$omitfields)) { //hide unwanted headers
	$th.='<th><a href="'.$portalbase.'&amp;get_sortlist='.$key.'&amp;flip='.$flip.$urlappend.'">'.$value. "</a></th>\r";
	}
}
//remove leading commas
$fields=substr($fields,1);
$table = "hl7data.hl7patientdata JOIN hl7data.gplistdata ON gp_id=gpcode";
if ($get_search=="pims") {
	if ($get_kchno) {
		$where = "WHERE kchno='$get_kchno'";
	}
	if ($get_lastname) {
		$birthdate=fixDate($get_dob);
		$where = "WHERE lastname='$get_lastname' and birthdate='$birthdate'";
	}
	echo $where;
		$sql = "SELECT $fields FROM $table $where $orderby $showportallimit";
	//	$result = $mysqli->query($sql);
		$numrows=$result->num_rows;
	//IF there are records
	if ($numrows=='0' && $where)
		{
		echo "<p class=\"header\">There are no $thisportalname found!</p>";
	}
	if ($numrows>1) {
			echo "<p class=\"header\">$numrows $thisportalname found $sortedby</p>";
		// table header w/ autosorts :)
		echo "<table><thead><tr>$th</tr></thead><tbody>";
		while($row = $result->fetch_assoc())
			{
			echo "<tr>";
		//------------DO NOT MODIFY BELOW!---------
		//render data rows
			foreach ($row as $key => $value) {
				$tdval=$row["$key"];
				$tdclass="";
				if (substr($key,-4)=="date") {
					$tdval = dmy($tdval) ;
				}
				if (!in_array($key,$omitfields)) {
					echo '<td>'.$tdval.'</td>';
				}
			}
			echo '</tr>';
			}
		echo '</tbody></table>';
		}
	
}
?>