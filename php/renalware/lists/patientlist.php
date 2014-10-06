<?php
//----Fri 20 Dec 2013----quicksearch fix for BROM pats and NHS No search
//----Wed 31 Oct 2012----rpv Add changed to RPV per HSC instruction
//--Mon Oct 15 09:51:02 SGT 2012--RPV option moved to right side
//----Tue 04 Sep 2012----rpvstatus add'n
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Patient List";
if($_GET["modalcode"])
	{
	$pagetitle.= ' (' . $_GET["modalcode"] . ')';
	}
include "$rwarepath/navs/topsimplenav.php";
echo '<div id="navdiv"><p>';
$sql= "SELECT modalcode, modality FROM modalcodeslist ORDER BY modality";
$result = $mysqli->query($sql);
$cnt=0;
while($row = $result->fetch_assoc()) {
	$cnt++;
	echo '<a class="btn" style="color: #069;" href="lists/patientlist.php?modalcode=' . $row['modalcode'] . '">' . $row['modality'] . "</a> ";
	if ($cnt==14)
		{
		echo '</p><p>';
		$cnt=0;
		}
	}
echo '</p></div>';
//get total
$limit = "LIMIT 1000"; // How many results should be shown at a time
$displaytext = "$siteshort patients--updated today"; //default
$where = "WHERE lasteventdate=CURDATE()"; // default
$orderby = "ORDER BY lastname, firstnames ASC"; //default
if($_GET["patzid"])
	{
	$patzid = $_GET["patzid"];
	$where = "WHERE patzid=$patzid";
	$displaytext = "found";
	}
if($_GET["findpat"])
	{
	$limit="";
	//fix "’" entry
	$quotefix=str_replace("’","'",$get_findpat);
	//to fix e.g. "O'Donnell":
	$patfix = $mysqli->real_escape_string($quotefix);
	$patorno = strtolower($patfix); //nb hospno may be entered in lc as well
	if(strstr($patorno,",")) //firstname entered and NOT hospno
		{
		$lastfirst = explode(",",$patorno);
		$ln = trim($lastfirst[0]);
		$fn = trim($lastfirst[1]);
		$where = "WHERE LOWER(lastname) LIKE '$ln%' AND LOWER(firstnames) LIKE '$fn%'";
		}
	else
		{
        // $inttest=(int)substr($patorno,1); //see if hospno e.g. Z999999 --> 999999
        // $where = ($inttest>0) ? "WHERE LOWER(hospno1) = '$patorno' OR LOWER(hospno2) = '$patorno' OR LOWER(hospno3) = '$patorno'" : "WHERE LOWER(lastname) LIKE '$patorno%'" ;
        //----Fri 20 Dec 2013----simplify as one query regardless of hospno or surname
        $where="WHERE LOWER(hospno1) = '$patorno' OR LOWER(hospno2) = '$patorno' OR LOWER(hospno3) = '$patorno' OR LOWER(hospno4) = '$patorno' OR LOWER(hospno5) = '$patorno' OR nhsno='$patorno' OR LOWER(lastname) LIKE '$patorno%'";
		}
	$displaytext = "<b>$quotefix</b> matches";
	}
if($_GET["modalcode"])
	{
	$modalcode=$_GET["modalcode"];
	$where = "WHERE modalcode = '$modalcode'";
	$displaytext = "<b>$modalcode</b> patients";
	$limit="";
	}
if($_GET["site"])
	{
	$sitecode=$_GET["site"];
	$limit="";
switch ($sitecode) {
	case 'QEH':
		$where = "WHERE hospno2 is not NULL";
		$displaytext = "<b>QEH</b> patients";
		break;
	case 'DVH':
		$where = "WHERE hospno3 is not NULL";
		$displaytext = "<b>DVH (Dartford)</b> patients";
		break;
	}		
}
$fields = "patzid, hospno1,nhsno, lastname, firstnames, sex, birthdate, age, modalcode, lasteventstamp,lasteventuser,rpvstatus,letters, meds, problems, modals, admissions, encounters, pathix, ixdata, bpwts,hdsess";
$sql= "SELECT $fields FROM patientdata LEFT JOIN patstats ON patzid=statzid $where $orderby $limit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if($_GET["patname"]) {
	echo '<small><font color="#ff0000">Select patient above, modify search below, or <a href="lists/patientlist.php">return to patient list</a></font></small><br>';
	include('incl/enterpatname.php');
} else {
	if (!$numrows) {
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	} else {
	echo "<p class=\"header\">$numrows $displaytext (max 1000).</p>";
	echo '<table class="tablesorter">
	<thead><tr>
	<th>add NEW</th>
	<th>Hosp No</th>
	<th>NHS No</th>
	<th>patient</th>
	<th>sex</th>
	<th>age</th>
	<th>DOB</th>
	<th>modal</th>
	<th colspan="8">view options</th>
	<th>last updated</th>
	<th>RPV?</th>
	</tr></thead><tbody>'; 
	while ($row = $result->fetch_assoc())
		{
		$trclass = ($row["modalcode"]=="death") ? 'death' : '';
		$zid = $row["patzid"];
		$dob=dmyyyy($row["birthdate"]);
        $rpv = ($row["rpvstatus"]) ? $row["rpvstatus"] : '<a href="ls/rpvlist.php?newzid='.$zid.'">Add</a>' ;
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
		$medslink = '<a href="pat/patient.php?vw=meds&amp;zid=' . $zid . '">'. $row["meds"].' meds</a>';
		$probslink = '<a href="pat/patient.php?vw=problems&amp;zid=' . $zid . '">' . $row["problems"].' probs</a>';
		$ixlink = '<a href="pat/patient.php?vw=ixworkups&amp;zid=' . $zid . '">' . $row["$ixdata"].' ix</a>';
		$admissionslink = '<a href="pat/patient.php?vw=admissions&amp;zid=' . $zid . '">' . $row["admissions"].' adm</a>';
		$encounterslink = '<a href="pat/patient.php?vw=encounters&amp;zid=' . $zid . '">' . $row["encounters"].' encs</a>';
		$letterslink = '<a href="pat/patient.php?vw=letters&amp;zid=' . $zid . '">' . $row["letters"].' lttrs</a>';
		$pathlink = '<a href="pat/patient.php?vw=pathology&amp;zid=' . $zid . '">' . $row["pathix"].' path ix</a>';
		$hdsesslink = '<a href="renal/renal.php?scr=hdnav&amp;zid=' . $zid . '">' . $row["hdsess"].' sess</a>';
		//make new
		$newlett = '<a href="letters/createletter.php?zid=' . $zid . '">lett</a>';
//		$newdisch = '<a href="letters/createdischarge.php?zid=' . $zid . '">disch</a>';
		$newenc = '<a href="pat/patient.php?zid=' . $zid . '&amp;vw=encounters&amp;mode=add">enc</a>';
		$lastevent = $row["lasteventstamp"] ." ".$row["lasteventuser"];
		echo "<tr class=\"$trclass\">
		<td>$newlett&nbsp;&nbsp;&nbsp;$newenc</td>
		<td>$adminlink</td>
		<td>".$row["nhsno"]."</td>
		<td>$patlink</td>
		<td>" . $row["sex"] ."</td>
		<td>" .$row["age"]. "</td>
		<td>" . $dob . "</td>
		<td>".$row["modalcode"]."</td>
		<td>$medslink</td>
		<td>$probslink</td>
		<td>$letterslink</td>
		<td>$admissionslink</td>
		<td>$ixlink</td>
		<td>$encounterslink</td>
		<td>$pathlink</td>
		<td>$hdsesslink</td>
		<td>" . $lastevent . "</td>
		<td>$rpv</td>
		</tr>";
		}
	echo '</tbody></table>';
	}
}
include '../parts/footer.php';
