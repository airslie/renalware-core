<?php
include '../req/confcheckfxns.php';
$pagetitle= "$siteshort Renal Letters &amp; Drafts ($displaycount Most Recent)";
include "$rwarepath/navs/topsimplenav.php";
?>
<div class="buttonsdiv">
<a style="color: #333;" href="lists/letterlist.php?status=draft">View/edit DRAFTs</a>&nbsp;&nbsp;
<a style="color: #333;" href="user/userletters.php">View my letters</a>&nbsp;&nbsp;
<a style="color: green" href="letters/newletter.php?stage=findpat">New Letter</a>&nbsp;&nbsp;
<a style="color: green;" href="letters/newdischarge.php?stage=findpat" title="create a new letter">New Disch Summ</a>&nbsp;&nbsp;
</div>
<form action="lists/letterlist.php" method="get"><fieldset>
Search field: <input type="radio" name="srch" value="patname" checked="checked" />patient (e.g. "smith, j" or "smith, jane")* &nbsp; &nbsp; <input type="radio" name="srch" value="author" />author (e.g. "brown") &nbsp;&nbsp; <input type="radio" name="srch" value="hospno" />Hosp No &nbsp; &nbsp; <input type="radio" name="srch" value="descr" />Description &nbsp;&nbsp;
<input type="text" name="srchtext" size="20" /><input type="submit" style="color: green;" value="Search Letters" /><br>*Important: a space must follow the comma i.e. "smith, jane" NOT "smith,jane".</fieldset>
</form>
<!--content here-->
<?php
$limit = $displaycount; // How many results should be shown at a time
$displaytext = " renal letters &amp; drafts at $siteshort"; //default
$showall = "";
$where = "";  // default
if($_GET["srch"]=="author")
		{
		$author = strtolower($_GET["srchtext"]);
		$where = "WHERE lower(authorlastfirst) LIKE '$author%'";
		$displaytext = "letters found for &ldquo;$author&rdquo;";
		$showall="<a href=\"lists/letterlist.php\">Show All Recent</a>";
		}
if($_GET["srch"]=="patname")
		{
		$patname = strtolower($_GET["srchtext"]);
		$where = "WHERE lower(patlastfirst) LIKE '$patname%'";
		$displaytext = "letters found for patient matching &ldquo;$patname&rdquo;";
		$showall="<a href=\"lists/letterlist.php\">Show All Recent</a>";
		}
if($_GET["srch"]=="descr")
		{
		$lettdescr = strtolower($_GET["srchtext"]);
		$where = "WHERE lower(lettdescr) LIKE '%$lettdescr%'";
		$displaytext = "letter descriptions found matching &ldquo;$lettdescr&rdquo;";
		$showall="<a href=\"lists/letterlist.php\">Show All Recent</a>";
		$limit=500;
		}
if($_GET["srch"]=="hospno")
		{
		$hospno = strtoupper($_GET["srchtext"]);
		$where = "WHERE letthospno='$hospno'";
		$displaytext = "letters for $hospno found";
		$showall="<a href=\"lists/letterlist.php\">Show All Recent</a>";
		}
if($_GET["status"]=="draft")
		{
		$where = "WHERE status='DRAFT'";
		$displaytext = "DRAFT letters found";
		$showall="<a href=\"lists/letterlist.php\">Show All Recent</a>";
		}
$displaytime = date("D j M Y  G:i:s");
$fields = "letter_id, letterzid, letthospno, typistinits, letterdate, clinicdate, lettertype, status, lettdescr, wordcount, patlastfirst, authorlastfirst, recipname, recipient, patref, printstage";
$tables = "letterdata";
$orderby = "ORDER BY letterdate DESC";
$sql= "SELECT letter_id FROM $tables $where";
$result = $mysqli->query($sql);
$numtotal = $result->num_rows;

$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $limit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	}
else
	{
	echo "<p class=\"header\">$numtotal $displaytext ($numrows most recent displayed).</p>";
	echo '<table class="tablesorter"><thead>
	<tr>
	<th>view</th>
	<th>Hosp No</th>
	<th>patient</th>
	<th>letterdate</th>
	<th>description [clinic date] <i>words</i></th>
	<th>author</th>
	<th>typist</th>
	<th>recipient</th>
	<th>pat options</th>
	</tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		$status = $row['status'];
		$letterzid=$row["letterzid"];
		$clinicdate=$row["clinicdate"];
		$letterdate=dmy($row["letterdate"]);
		$descr = $row["lettdescr"] . ' <i>' . $row["wordcount"] . '</i>';
		$descr = $row["lettdescr"] . ' <i>' . $row["wordcount"] . "</i>";
		if ($clinicdate) {
			$descr = $row["lettdescr"]. ' ['.dmy($clinicdate) . '] <i>' . $row["wordcount"] . "</i>";
		}
		
		$viewURL='letters/viewletter.php?zid=' . $letterzid . '&amp;letter_id=' . $row["letter_id"];
		$viewedit = '<a href="' . $viewURL . '"  target="_blank" onclick="window.open(\'' . $viewURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">view ' .  $status . '</a>';
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $letterzid . '">' . $row["patlastfirst"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $letterzid . '">' . $row["letthospno"] . '</a>';
		$recip = $row['recipname']; //speeds up?
		$newpatletter = '<a href="letters/createletter.php?zid=' . $letterzid . '&amp;stage=start">new lttr</a>';
		$viewpatletters = '<a href="pat/patient.php?vw=letters&amp;zid=' . $letterzid . '">pat lttrs</a>';
		echo '<tr class="' . $status . '">
		<td>'.$viewedit.'</td>
		<td>' . $adminlink . '</td>
		<td>' . $patlink . '</td>
		<td>' . $letterdate . '</td>
		<td>' . $descr . '</td>
		<td>' . $row["authorlastfirst"] . '</td>
		<td>' . $row["typistinits"] . '</td>
		<td>' . $recip . '</td>
		<td>'. $newpatletter . '&nbsp;&nbsp;' . $viewpatletters . '</td>
		</tr>';
		}
		echo '</tbody></table>';
	}
 include '../parts/footer.php';
?>