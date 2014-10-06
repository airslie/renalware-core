<?php
//----Fri 10 May 2013----revert to ixdata
//----Thu 06 Dec 2012----for ixdata2
$ixtable="pathol_ixdata";
$obxtable="pathol_obxdata";
include "/var/conns/renalwareconn.php";
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
echo '<div class="ixdatadivx">';
echo "<p class=\"pathheader\"><b>$ixname</b> ($ixcode) Requested<br>$ixstamp by $requestor</p>";
$sql = "SELECT * FROM hl7data.$obxtable LEFT JOIN hl7data.pathol_obxcodes ON obxcode=code WHERE ix_id=$ix_id";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo '<table class="tablesorter">
<tr><th>Code</th><th>Ix (<i>hx</i>=show history)</th><th>Result</th>';
while($row = $result->fetch_assoc())
	{
    $obxcode=$row["obxcode"];
    $obxname=$row["obxname"];
    $obxdt=$row["obxdt"];
    $obxtext=$row["obxresult"].nl2br($row["obxcomment"]); //one or other
    $viewobxlist = ($row["obxtype"]!="FT") ? "<a href=\"javascript:getObxdata('$ixpid','$obxcode')\"><i>hx</i></a>" : '' ;
    echo "<tr><td>$obxcode</td><td>$obxname $viewobxlist</td><td>$obxtext</td></tr>";
	}
echo '</table>
</div>';
?>
<script type="text/javascript" charset="utf-8">
function getObxdata(thispid,thisobxcode){
	$.get("pathology/ajax_getobxdata.php", {obxpid: thispid, obxcode: thisobxcode},
	   function(data){
           $('#showobxdatadiv').show();
			$('#showobxdatadiv').html(data);
		});
	}
</script>
