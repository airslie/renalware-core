<?php
//----Fri 10 May 2013----revert to ixdata/obxdata
//----Thu 06 Dec 2012----for new ixdata2
$ixtable='pathol_ixdata';
$thisscr='resultsbrowser';
$sql="SELECT ixcode, ixname, count(ix_id) as ixcount FROM hl7data.$ixtable WHERE ixpid='$pid' GROUP BY ixcode";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
    echo '<form action="pat/patient.php" method="get">
	<input type="hidden" name="zid" value="'.$zid.'" id="zid">
	<input type="hidden" name="vw" value="pathology" id="vw">
	<input type="hidden" name="scr" value="'.$thisscr.'" id="scr">
    <fieldset>
    <select name="ixcode">';
    echo "<option value=\"\">Select from $title $lastname&rsquo;s investigations</option>\n";
        while($row = $result->fetch_assoc())
        {
        echo '<option value="'.$row["ixcode"].'">'. $row["ixname"]. ' ['.$row["ixcount"]."]</option>\n";
        }
    echo '</select>&nbsp;&nbsp;
    <input type="submit" style="color: green;" value="Display selected investigations" /> &nbsp;&nbsp;
    <input type="button" class="ui-state-default" style="color: red;" value="Show All" onclick="self.location=\''.$rwareroot.'/pat/patient.php?vw=pathology&amp;zid='.$zid.'&amp;scr='.$thisscr.'\'"/></fieldset></form>';
}
//may have no limit
$limitdisplay=FALSE;
$limit = ($limitdisplay) ? "LIMIT $limitdisplay" : "" ;
$table = "hl7data.$ixtable";
$where = "WHERE ixpid='$hospno1'"; // default
$thisixcode="";
if ($_GET["ixcode"]) {
	$thisixcode=$_GET["ixcode"];
	$where .= " AND ixcode='$thisixcode'";
}
$orderby = "ORDER BY ixdate DESC"; //incl ORDER BY prn
$sql = "SELECT * FROM $table $where $orderby $limit";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows)
	{
	echo '<div id="leftpathcol">';
	echo "<p class=\"resultsheader\">$numrows <b>$thisixcode</b> investigations (scroll to view entire list).</p>";
	echo '<div id="ixlistdiv">
	<table class="ixlist" style="width: 300px;"><tbody>';
	while($row = $result->fetch_assoc())
	 {
	$pathixURL="javascript:getIxdata('".$row["ix_id"]."')";
	$viewpathix = '<a href="' . $pathixURL . '">' . $row["ixname"] . '</a>';
	echo '<tr id="'.$row["ix_id"].'" class=""><td>' . $row["ixstamp"] . '--'.$viewpathix.'</td></tr>';
	}
	echo '</tbody></table>
		</div>
	</div>';
	} else {
    	echo "<p class=\"resultsheader\">There are no investigations recorded!</p>";
	}
    echo '<div id="pathrightcol">
		<div id="showixdatadiv" style="width: 320px;float: left"></div>
		<div id="showobxdatadiv" style="margin-left:5px;float:left; width: 250px;"></div>
	</div>';
?>
<script type="text/javascript" charset="utf-8">
function getIxdata(thisixid){
	$.get("pathology/ajax_getixdata.php", {ix_id: thisixid},
	   function(data){
			$('#showixdatadiv').html(data);
            $('#showobxdatadiv').hide();
		});
	}
</script>