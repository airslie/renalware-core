<?php
//if updated
if ($_GET['update']=="profile")
	{
	include( 'hd/run/runupdateprofile.php' );
	//refresh data for display
	include "$rwarepath/data/hddata.php";
	} // end update IF
?>
<table border="0" cellspacing="5" cellpadding="5">
<tr>
<td valign="top">
<div class="scroll_box">
<?php
$site=$currsite; //from curr pat!
$where = "WHERE modalcode LIKE 'HD%' AND currsite='$site'";
$fields = "hdpatzid, lastname, firstnames, age";
$tables ="hdpatdata JOIN patientdata ON hdpatzid=patzid ";
$order="ORDER BY lastname, firstnames";
$sql= "SELECT $fields FROM $tables $where $order";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
while ($row = $result->fetch_assoc())
	{
	$zid = $row["hdpatzid"];
	$showage = '<i>(' . $row["age"] . ")";
	$patlink = '<a href="renal/renal.php?scr=hdnav&amp;hdmode=scrollprofiles&amp;site=' . $site . '&amp;zid=' . $zid . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
	echo "$patlink $showage <br>";
	}
?>

</div>
</td>
<td valign="top">
<?php
$zid=$_GET['zid']; //b/c scrollbar changes zids
include "$rwarepath/data/hddata.php";
include "$rwarepath/renal/hd/hdprofile_incl.php";
//display portal with updateable session form
if (isset($_GET['updatesess']))
	{
	include( 'hd/run/runupdatesession.php' );
	} // end update IF
$sesslimit=12;
include('hd/sessions_portal.php');
?>
</td>
</tr>
</table>
