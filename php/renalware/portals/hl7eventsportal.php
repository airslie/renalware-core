<h3>PIMS/HL7 Data Events</h3>
<?php
$fields = "
mshdatetime,
mshevent,
event,
h.kchno,
h.nhsno,
h.lastname,
h.firstname,
h.middlename,
date(birthdatetime) as birthdate,
LEFT(h.sex,1) as sex,
h.addr_street,
h.addr_other,
h.addr_city,
h.addr_postcode,
DATE(deathdatetime) as deathdate,
h.deathyn,
h.providernameaddr,
h.gp_lastname,
h.gp_givenname,
h.gp_middlename
";
$sql= "SELECT $fields FROM register h JOIN eventtypes ON mshevent=eventcode WHERE kchno='$hospno1' ORDER BY register_id DESC";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">$numrows PIMS events since 3 Feb 2008</p>";
	echo '<table class="tablesorter">
	<thead><tr>
	<th>event date/time</th>
	<th>type</th>
	<th>event</th>
	<th>KCH No</th>
	<th>NHS No</th>
	<th>Patient</th>
	<th>DOB</th>
	<th>Sex</th>
	<th>address</th>
	<th>Death date</th>
	<th>GP</th>
	<th>Practice</th>
	</tr></thead><tbody>';
	while ($row = $result->fetch_assoc())
		{
		$showdeathdate = ($row["deathyn"]=="Y") ? dmyyyy($row["deathdate"]) : "&nbsp;" ;
		$dob=dmyyyy($row["birthdate"]);
		$gp=strtoupper($row["gp_givenname"].' '.$row["gp_middlename"] . ' '.$row["gp_lastname"]);
		$gp=str_replace("  "," ", $gp);
		$renalpatlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["patzid"] . '">' . $row["modalcode"] . '</a>';
		$viewrenal = ($row["patzid"]) ? $renalpatlink : "&nbsp;" ;
		echo '<tr>
			<td>' . $row["mshdatetime"] . '</td>
			<td>' . $row["mshevent"] . '</td>
			<td><b>' . $row["event"] . '</b></td>
			<td>' . $row["kchno"] . '</td>
			<td>' . $row["nhsno"] . '</td>
			<td><b>' . $row["lastname"] . ', ' . $row["firstname"] . ' ' . $row["middlename"] . '</b></td>
			<td>' . $dob . '</td>
			<td>' . $row["sex"] . '</td>
			<td>' . $row["addr_postcode"] . '</td>
			<td>' . $showdeathdate . '</td>
			<td>' . $gp . '</td>
			<td>' . $row["providernameaddr"] . '</td>
			</tr>';
		}
	echo '</tbody></table>';
?>