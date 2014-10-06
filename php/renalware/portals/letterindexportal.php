<?php
//get total no
$where = "WHERE l.letterzid=$zid";
$showall="<a href=\"pat/patient.php?vw=letterindex&amp;zid=$zid\">Show all letters</a>";
$displaytext = "letters &amp; drafts recorded"; //default
if (isset($_GET['lettdescr_id'])) {
	$lettdescr_id=$_GET['lettdescr_id'];
	$where .= " AND lettdescr_id=$lettdescr_id";
	$displaytext = "letters for $firstnames $lastname ($showall)"; //default

	}
if (isset($_GET['uidflag'])) {
	$uidflag=$_GET['uidflag'];
	if ($uidflag=='yes') {
		$where .= " AND letteruid=$uid";
		$displaytext .= " entered by $user ($showall)";
	}
}
$sql= "SELECT letterindex_id FROM letterindex l $where";
$result = $mysqli->query($sql);
$numtotal = $result->num_rows;
$limit = $portallimit;
$showall = "";
$fields = "letterindex_id, typistinits, l.letterdate, lettertype, clinicdate, lettdescr, lettertext, wordcount, authorlastfirst, recipname";
$tables = "letterindex l";
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
	<table class=\"tablesorter\"><tbody>";
	while ($row = $result->fetch_assoc())
		{
		$lettid=$row["letterindex_id"];
		$lettertext=$row["lettertext"];
		$clinicdate = $row['clinicdate'];
		$descr = '<b>'.$row["lettdescr"] . '</b>';
		if ($clinicdate) {
			$descr = '<b>'. $row["lettdescr"]. '--'.dmy($clinicdate) . '</b>';
		}
		$showhide = "<a class=\"tg\" onclick=\"toggl('lett$lettid');\">toggle</a>";
		$viewURL='letters/viewletter.php?zid=' . $row['letterzid'] . '&amp;letter_id=' . $lettid;
		$viewedit = '<a href="' . $viewURL . '" target="_blank" onclick="window.open(\'' . $viewURL . '\',\'Letter\',\'toolbar=no,scrollbars=yes,width=800,height=900,left=500,top=300,resize=yes\'); return(false);">view</a>';
		$recip = $row['recipname'];
		echo '<tr><td>' . dmyyyy($row["letterdate"]) . "</td><td>" . $row["authorlastfirst"] . "</td><td>".$row["wordcount"]."</td><td style=\"width: 700px;\">$viewedit &nbsp;&nbsp;$showhide  &nbsp;&nbsp;$descr  to $recip";
		echo "<p id=\"lett$lettid\" style=\"display:none;padding:2px;width: 600px; background-color:#ff9;font-size: 1em;\">$lettertext</p>";
		echo "</td></tr>";
		}
	echo "</tbody></table>";
	}
	?>