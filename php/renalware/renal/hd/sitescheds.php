<?php
//--------Page Content Here----------
?>
<p>
<a class="ui-state-default" style="color: green;" href="renal/hdlists.php?list=sitescheds">All sites</a>&nbsp;&nbsp;
<?php
$pagetitle='sitelist';
	$popcode="sitecode";
	$popname="sitename";
	$poporder="ORDER BY sitename";
	$poptable="sitelist";
$sql= "SELECT $popcode, $popname FROM $poptable $poporder";
$result = $mysqli->query($sql);
while($row = $result->fetch_row()) {
	$style = ($get_site==$row["0"]) ? "color: red; background: yellow;" : "color: #333" ;
echo '<a class="ui-state-default" style="'.$style.'" href="renal/hdlists.php?list=sitescheds&amp;site=' . $row['0'] . '">' . $row['1'] . "</a>&nbsp;&nbsp;";
}
?>
</p>
<table class="list">
<tr>
<th>HD site</th>
<th>schedule</th>
<th>pats</th>
<th colspan="3">options (appear in new browser window)</th>
</tr>
<?php 
//default show all sites
$sql= "SELECT currsite, site_sched_slot, sched_slot, COUNT(sitezid) as pats FROM viewsitescheds GROUP BY site_sched_slot ORDER BY site_sched_slot";
$display="$siteshort HD schedules displayed (all sites)";
if ( $_GET['site'] )
{
	$site=$_GET['site'];
	$sql= "SELECT currsite, site_sched_slot, sched_slot, COUNT(sitezid) as pats FROM viewsitescheds WHERE currsite='$site' GROUP BY sched_slot ORDER BY sched_slot";
	$display = "$site current HD schedules displayed";
}
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">$numrows $display</p>";
$patcount=0;
while ($row = $result->fetch_assoc())
	{
	$patcount += $row["pats"];
	list($site,$sched,$slot)=explode("-",$row["site_sched_slot"]);
	echo '<tr>
	<td><b>' . $row["currsite"] . '</b></td>
	<td>' . $row["sched_slot"] . '</td>
	<td>&nbsp;&nbsp;<i>' . $row["pats"] . '</i></td>
	<td><a href="renal/hdlists.php?list=hdpatlist&sss=' . $row["site_sched_slot"] . '" >view patients</a></td>
	<td><a href="renal/hd/printhdprofiles.php?sss=' . $row["site_sched_slot"] . '" >print HD Profiles</a></td>
	<td><a href="renal/hdscreens.php?site=' . "$site&amp;sched=$sched&amp;slot=$slot" . '" >HD Screens: '.$row["site_sched_slot"].'</a></td>
</tr>';
}
?>
<tr class="trhilite"><td colspan="2"><b>Total patients</b></td><td><b><?php echo $patcount; ?></b></td></tr>
</table>