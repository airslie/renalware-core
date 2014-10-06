<?php
//get total no
$where = "WHERE l.letterzid=$zid";
$showall="<a href=\"pat/patient.php?vw=letters&amp;zid=$zid\">Show all letters</a>";
$displaytext = "letters &amp; drafts recorded"; //default
if (isset($_GET['lettdescr'])) {
	$lettdescr=$_GET['lettdescr'];
	$where .= " AND lettdescr='$lettdescr'";
	$displaytext = "$lettdescr letters for $firstnames $lastname ($showall)"; //default

	}
if (isset($_GET['uidflag'])) {
	$uidflag=$_GET['uidflag'];
	if ($uidflag=='yes') {
		$where .= " AND lettuid=$uid";
		$displaytext .= " entered by $user ($showall)";
	}
}
$sql= "SELECT letter_id FROM letterdata l $where";
$result = $mysqli->query($sql);
$numtotal = $result->num_rows;
$limit = $portallimit;
$showall = "";
$displaytime = date("D j M Y  G:i:s");
$fields = "letter_id, typistinits, l.letterdate, lettertype, clinicdate, status, lettdescr, ltext as lettertext, wordcount, authorsig, recipname, recipient, printstage";
$tables = "letterdata l JOIN lettertextdata t ON letter_id=lettertext_id";
//nb flag set in config.php
$orderby = "ORDER BY l.letterdate DESC";
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $limit";
if ($show=='all')
	{
	$sql= "SELECT $fields FROM $tables WHERE letterzid=$zid $orderby";
	}
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	}
else
	{
	echo "<p class=\"header\">$numtotal $displaytext ($numrows displayed). ('Toggle' to view text.) Numbers in brackets indicate word count.</p>
	<ul class=\"portal\">";
	while ($row = $result->fetch_assoc())
		{
		$lettid=$row["letter_id"];
		$letttext=$row["lettertext"];
		$status = $row['status'];
		$clinicdate = $row['clinicdate'];
		$descr = '<em>'.$row["lettdescr"] . '</em> [' . $row["wordcount"] . "]";
		if ($clinicdate) {
			$descr = '<em>'.$row["lettdescr"] . '</em>--'.dmy($clinicdate) . ' [' . $row["wordcount"] . "]";
		}
		$showhide = "<a class=\"tg\" onclick=\"toggl('lett$lettid');\">toggle</a>";
		$viewURL='letters/viewletter.php?zid=' . $zid . '&amp;letter_id=' . $lettid;
		$viewedit = '<a href="' . $viewURL . '"  target="_blank" onclick="window.open(\'' . $viewURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">view</a>';
		$recip = substr($row['recipient'], 0, 60); //speeds up?
		echo '<li>' . $viewedit . '&nbsp;&nbsp; ' . $showhide  . '&nbsp;&nbsp;' . dmyyyy($row["letterdate"]) . "&nbsp;&nbsp; $descr by " . $row["authorsig"] . " <i>to $recip...</i></li>";
		echo "<li id=\"lett$lettid\" style=\"display:none; padding:3px;width: 1000px; background-color:#ff9;font-size: 1em;\"><p>$letttext</p></li>";
		}
	echo "</ul>";
	}
	?>