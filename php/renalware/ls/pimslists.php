<?php
//Wed Oct 22 16:44:25 IST 2008
include '../req/confcheckfxns.php';
//config lists
$pagetitle= "Search PIMS";
//set mod to select vwbar options
include "$rwarepath/navs/topsimplenav.php";
$baseurl="ls/pimslists.php";
include '/Users/lat/projects/renalwarev2/tmp/renalwareconn.php';

?>
<form action="ls/pimslists.php" method="get" accept-charset="utf-8">
	<input type="hidden" name="search" value="pims" id="search" />
	<fieldset>
		<legend>Search by KCH No or Last Name/DOB (Data are from c. Feb 2008)</legend>
		<p>Enter <b>either</b> KCH No or Patient surname. DOB is optional</p>
		<label for="kchno">KCH No</label><input type="text" name="kchno" size="7" id="kchno" /> <b>OR</b> <label for="lastname">Last Name</label><input type="text" name="lastname" size="7" id="lastname" /> &nbsp;&nbsp;&nbsp;<label for="dob">DOB</label><input type="text" name="dob" size="7" id="dob" /> (Recommended with Last Name search to limit results) 
		
		</fieldset>
	<p><input type="submit" style="color: green;" value="Search &rarr;" /></p>
</form>
<?php
//-------SET FORM VARS--------
$thisvw="searchpims";
$displaytext = "PIMS patient matches"; //default
$fieldslist=array(
	'kchno'=>'KCH No',
	'lastname'=>'last name',
	'firstname'=>'first name',
	'birthdate'=>'DOB',
	'sex'=>'sex',
	'nhsno'=>'NHS No',
	'addr_postcode'=>'postcode',
	'providernameaddr'=>'Practice',
	'gplastname'=>'GP surname',
	);
//build GET
$gets="search=pims&amp;";
if ($_GET) {
		if ($get_kchno) {
			$gets.="kchno=$get_kchno&amp;";
		}
		if ($get_lastname) {
			$gets.="lastname=$get_lastname&amp;";
		}
		if ($get_dob) {
			$gets.="dob=$get_dob&amp;";
		}
		if ($get_yob) {
			$gets.="yob=$get_yob&amp;";
		}
}
$thisportalname="PIMS Patients **BETA**";
$portalbase="pimslists.php";
$fields="";
$omitfields=array();
$th ="";
$flip = ($get_flip=="DESC") ? "ASC" : "DESC" ;
$orderby = "ORDER BY lastname, firstname" ;
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
	$th.='<th><a href="'.$portalbase.'?'.$gets.'sortlist='.$key.'&amp;flip='.$flip.$urlappend.'">'.$value. "</a></th>\r";
	}
}
//remove leading commas
$fields=substr($fields,1);
$table = "hl7data.hl7patientdata";
if ($get_search=="pims") {
	if ($get_kchno) {
		$getkchno=strtoupper($get_kchno);
		$where = "WHERE kchno='$getkchno'";
	}
	if ($get_lastname) {
		$lowerlast=strtolower($get_lastname);
		$where = "WHERE LOWER(lastname)='$lowerlast'";
	}
	if ($get_dob) {
		$birthdate=fixDate($get_dob);
		$where .= " AND birthdate='$birthdate'";
	}
	if ($get_yob) {
		$where .= " AND YEAR(birthdate)=$get_yob";
	}
		$sql = "SELECT $fields FROM $table $where $orderby";
		$result = $mysqli->query($sql);
		$numrows=$result->num_rows;
	//IF there are records
	if ($numrows=='0')
		{
		echo "<p class=\"header\">There are no $thisportalname found!</p>";
	} else {
			echo "<p class=\"header\">$numrows patients found $where $sortedby</p>";
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
				echo '<td>'.$tdval.'</td>';
			}
			echo '</tr>';
			}
		echo '</tbody></table>';
		}
	
}
include '../parts/footer.php';

?>