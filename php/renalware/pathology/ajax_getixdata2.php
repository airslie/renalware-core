<?php
//----Thu 06 Dec 2012----for ixdata2
$ixtable="pathol_ixdata";
$obxtable="pathol_obxdata";
realpath($_SERVER['DOCUMENT_ROOT']).'/../../tmp/renalwareconn.php';
$ix_id = (int)$_GET["ix_id"];
$sql = "SELECT * FROM hl7data.$ixtable WHERE ix_id=$ix_id LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$ixstamp=$row["ixstamp"];
$ixcode=$row["ixcode"];
$ixpid=$row["ixpid"];
$ixname=$row["ixname"];
$requestor=$row["requestor"];
//show
/*
CREATE TABLE `final_obx` (
  `obx_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `importstamp` datetime DEFAULT NULL,
  `obxpid` varchar(12) DEFAULT NULL,
  `ixcode` varchar(6) DEFAULT NULL,
  `obxcode` varchar(6) DEFAULT NULL,
  `obxtype` char(2) DEFAULT NULL,
  `obxdt` datetime DEFAULT NULL,
  `obxresult` varchar(12) DEFAULT NULL,
  `obxcomment` varchar(500) DEFAULT NULL,
  */
echo '<div class="ixdatadiv">';
echo "<p class=\"pathheader\"><b>$ixname</b> ($ixcode) Requested<br>$ixstamp by $requestor</p>";
$sql = "SELECT * FROM hl7data.$obxtable LEFT JOIN hl7data.pathol_obxcodes ON obxcode=code WHERE obxpid='$ixpid' AND ixcode='$ixcode' AND obxdt='$ixstamp'";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo "TEST: $sql <br>";
echo '<table class="tablesorter">
<tr><th>Code</th><th>Ix (<i>hx</i>=show history)</th><th>Result</th>';
while($row = $result->fetch_assoc())
	{
    $obxcode=$row["obxcode"];
    $obxname=$row["obxname"];
    $obxdt=$row["obxdt"];
    $obxtext=$row["obxresult"].nl2br($row["obxcomment"]); //one or other
    $viewobxlist = ($row["obxtype"]!="FT") ? "<a href=\"javascript:getObxdata2('$ixpid','$obxcode')\"><i>hx</i></a>" : '' ;
    echo "<tr><td>$obxcode</td><td>$obxname $viewobxlist</td><td>$obxtext</td></tr>";
	}
echo '</table>
</div>';
?>
<script type="text/javascript" charset="utf-8">
function getObxdata2(thispid,thisobxcode){
	$.get("pathology/ajax_getobxdata2.php", {obxpid: thispid, obxcode: thisobxcode},
	   function(data){
			$('#showobxdatadiv').html(data);
		});
	}
</script>
