<?php
include '../req/confcheckfxns.php';
$pagetitle= $sitelong . ' Sessions List';
include "$rwarepath/navs/topusernav.php";
?>
<a class="ui-state-default" style="color: purple;" href="sessionlist.php?show=curr">Show active sessions only</a></li>
<?php
if($_GET["show"]=="curr")
	{
	$display = 200;
	$displayquery = "SELECT session_id FROM renalware.renalsessions WHERE activeflag=1";
	$displaytext = "active sessions";
	$listwhere = "WHERE activeflag=1";
	}
$displaytext = "sessions"; //default
$orderby = "ORDER BY session_id DESC"; //incl ORDER BY prn
$sql= "SELECT session_id, starttime, sessuser, sessuid, user_ipaddr, lasteventtime, endtime, activeflag FROM renalware.renalsessions $listwhere $orderby LIMIT 50";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">$numrows $displaytext (50 max)</p>";
?>
<table class="tablesorter">
<thead><tr>
	<th>sess id</th>
	<th>starttime</th>
	<th>user</th>
	<th>IP address</th>
	<th>last event time</th>
	<th>end time</th>
</tr>
</thead><tbody>
<?php
while($row = $result->fetch_assoc()) {
	$trclass = ($row["activeflag"]==1) ? "hilite" : "" ;
	echo "<tr class=\"$trclass\">
		<td>" . $row["session_id"] . '</td>
		<td class="start">' . $row["starttime"] . "</td>
		<td><b>" . $row["user"] . "</b></td>
		<td>" . $row["user_ipaddr"] . "</td>
		<td>" . $row["lasteventtime"] . "</td>
		<td class=\"term\">" . $row["endtime"] . "</td></tr>";
}
?>
</tbody></table>
<?php
include '../parts/footer.php';
?>