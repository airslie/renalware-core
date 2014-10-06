<?php
//----Mon 25 Feb 2013----streamlining
//if updated
if ($_GET['update']=="profile")
	{
	include( 'hd/run/runupdateprofile.php' );
	} // end update IF
echo '<table>
    <tr>
    <td valign="top">';

include "$rwarepath/data/hddata.php";
include "$rwarepath/renal/hd/hdprofile_incl.php";
echo '</td>
<td valign="top">
    <p class="header">Dry Weight Data</p>
    <table class="list">
    <tr>
    	<th>date</th>
    	<th>Wt</th>
    	<th>Assessor</th>
    </tr>';
    //DRY WT PORTAL
    $sql= "SELECT drywtassessdate, dryweight, drywtassessor FROM hddryweightdata WHERE drywtzid=$zid ORDER BY drywt_id DESC LIMIT 8";
    $result = $mysqli->query($sql);
    	while ($row = $result->fetch_assoc()) {
    		echo "<tr>
    			<td>" . dmyyyy($row["drywtassessdate"]) . "</td>
    			<td><b>" . $row["dryweight"] . "</b></td>
    			<td>" . $row["drywtassessor"] . "</td>
    		</tr>";
    		}
echo '</table>
</td>
</tr>
</table>';
//display portal with updateable session form
$sesslimit=12;
include('hd/sessions_portal.php');
