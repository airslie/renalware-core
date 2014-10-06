<?php
//handle MARK READ
if ($get_markmsg) {
	$sql = "UPDATE messagedata SET readflag='1',readstamp=NOW() WHERE message_id=$get_markmsg LIMIT 1";
	$result = $mysqli->query($sql);
	$eventtype="e-Message ID $get_markmsg READ by $user";
	include "$rwarepath/run/logevent.php";
}
//display UNREAD msgs
$displaytext = "UNREAD $siteshort messages for $user (highlighted=URGENT)"; //default
$fields = "message_id, messagezid, messagestamp,hospno1,messagesubj,messagetext,urgentflag,authorsig,concat(lastname, ', ', firstnames) as patlastfirst, DATEDIFF(NOW(), date(messagestamp)) as daysunread";
$tables = "messagedata JOIN userdata ON message_uid=uid JOIN patientdata on messagezid=patzid";
$where = "WHERE recip_uid=$uid AND readflag='0'";
$orderby = "ORDER BY message_id ASC";
$sql= "SELECT $fields FROM $tables $where $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"headergray\">There are no UNREAD messages for $user</p>";
	}
else
	{
	echo '<p class="alertbig">ALERT: You have unread message(s)! Please review.</p>';
	echo "<p class=\"header\">$numrows $displaytext. <br>";
	echo '<table class="display"><thead>
		<tr>
    <th>Days Old</th>
    <th>From</th>
    <th>Sent</th>
    <th>HospNo</th>
    <th>Patient</th>
    <th>Subject (Click to read message)</th>
    </tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		$msgsubj = $row["messagesubj"];
		$msgid = $row["message_id"];
		$subj = ($row["urgentflag"]=="1") ? "URGENT: $msgsubj" : $msgsubj ;
		$trstyle = ($row["urgentflag"]=="0") ? "" : ' style="background: #ffcc00"' ;
		$showhide = "<a class=\"tg\" onclick=\"toggl('msg$msgid');\">$subj</a>";
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["messagezid"] . '">' . $row["hospno1"] . '</a>';
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["messagezid"] . '">' . $row["patlastfirst"] . '</a>';
		echo '<tr' . $trstyle . '>
		<td>'.$row["daysunread"].' d</td>
		<td>' . $row["authorsig"] . '</td>
		<td>' . $row["messagestamp"] . '</td>
		<td>' . $adminlink . '</td>
		<td>' . $patlink . '</td>
		<td><b>' . $showhide . '</b>'.
		'<div id="msg'.$msgid.'" style="display:none;"><p style="padding:2px;background-color:#ff9;font-size: 1.1em;">'.$row["messagetext"].'
		</p><br><a class="ui-state-default" style="color: purple;" href="user/userhome.php?markmsg='.$row["message_id"].'">Mark READ</a> or <a class="ui-state-default" style="color: green;" href="javascript:toggl(\'msg'.$msgid.'\');">Keep as NEW</a></div></td>
		</tr>';
		}
	echo '</tbody>
    </table><br>';
	}
