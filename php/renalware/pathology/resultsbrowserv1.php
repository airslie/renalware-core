<?php
$ixcodelist="<option value=\"\">Select from $title $lastname&rsquo;s investigations</option>\n";
$sql="SELECT ixcode, ixname, count(ix_id) as ixcount FROM hl7data.pathol_ixdata WHERE ixpid='$pid' GROUP BY ixcode";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
while($row = $result->fetch_assoc())
{
$ixcodelist.= '<option value="'.$row["ixcode"].'">'. $row["ixname"]. ' ['.$row["ixcount"]."]</option>\n";
}
?>
<?php if ($numrows): ?>
	<form action="pat/patient.php" method="get">
	<input type="hidden" name="zid" value="<?php echo $zid ?>" id="zid">
	<input type="hidden" name="vw" value="pathology" id="vw">
	<input type="hidden" name="scr" value="resultsbrowser" id="scr">
<div id="pathdatasetdiv">
<fieldset>
<select name="ixcode"><?php echo $ixcodelist; ?></select>&nbsp;&nbsp;
<input type="submit" style="color: green;" value="Display selected investigations" /> &nbsp;&nbsp;
<input type="button" class="ui-state-default" style="color: red;" value="Show All" onclick="self.location='<?php echo $rwareroot ?>/pat/patient.php?vw=pathology&amp;zid=<?php echo $zid ?>&amp;scr=resultsbrowser'"/></fieldset>
</form>
<?php endif ?>
<?php
//may have no limit
$limitdisplay=FALSE;
$limit = ($limitdisplay) ? "LIMIT $limitdisplay" : "" ;
//$fields = "ix_id, ixstamp, ixcode, requestor, obxblock";
$fields = "ix_id, ixstamp, ixcode, ixname";
$tables = "hl7data.pathol_ixdata";
$where = "WHERE ixpid='$hospno1'"; // default
$thisixcode="";
if ($_GET["ixcode"]) {
	$thisixcode=$_GET["ixcode"];
	$where .= " AND ixcode='$thisixcode'";
}
$orderby = "ORDER BY ixdate DESC"; //incl ORDER BY prn
$sql = "SELECT $fields FROM $tables $where $orderby $limit";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"resultsheader\">There are no investigations recorded! </p>";
	}
else
	{
	echo '<div id="leftpathcol">';
	echo "<p class=\"resultsheader\">$numrows <b>$thisixcode</b> investigations (scroll to view entire list).</p>";
	echo '<div id="ixlistdiv">
	<table class="ixlist" style="width: 320px;"><tbody>';
	while($row = $result->fetch_assoc())
	 {
		$pathixURL="javascript:getIxdata('".$row["ix_id"]."')";
		$viewpathix = '<a href="' . $pathixURL . '">' . $row["ixname"] . '</a>';
		echo '<tr id="'.$row["ix_id"].'" class=""><td>' . $row["ixstamp"] . '--'.$viewpathix.'</td></tr>';
		}
	echo '</tbody></table>
		</div>
		</div>';
	}
?>
<!-- ajax form to find patient	 -->
	<script type="text/javascript">
	<!-- 
	function getIxdata(ix_id){
		var ajaxRequest;
		ajaxRequest = new XMLHttpRequest();
		ajaxRequest.onreadystatechange = function(){
			if(ajaxRequest.readyState == 4){
				var ajaxDisplay = document.getElementById('ajax_showixdata');
				ajaxDisplay.innerHTML = ajaxRequest.responseText;
			}
		}
		var queryString = "?ix_id=" + ix_id;
		ajaxRequest.open("GET", "pathology/ajax_getixdata.php" + queryString, true);
		ajaxRequest.send(null);
		//document.getElementById(ix_id).className = "hi";
	}
	function getObxdata(obxcode,pid){
		var ajaxRequest;
		ajaxRequest = new XMLHttpRequest();
		ajaxRequest.onreadystatechange = function(){
			if(ajaxRequest.readyState == 4){
				var ajaxDisplay = document.getElementById('ajax_showobxdata');
				ajaxDisplay.innerHTML = ajaxRequest.responseText;
			}
		}
		var queryString = "?obxcode=" + obxcode + "&pid=" + pid;
		ajaxRequest.open("GET", "pathology/ajax_getobxdata.php" + queryString, true);
		ajaxRequest.send(null); 
	}
	//-->
	</script>
	<div id="pathrightcol">
		<div id="ajax_showixdata" style="width: 300px;float: left;"></div>
		<div id="ajax_showobxdata" style="margin-left:10px;float:left; width: 290px;"></div>
	</div>

</div>