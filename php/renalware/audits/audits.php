<?php
include realpath($_SERVER['DOCUMENT_ROOT']).'/../../tmp/renalwareconn.php';
include '../req/confcheckfxns.php';
$thisaudit = ($get_audit) ? $get_audit : "epo" ;
//get lastrun and auditname here :)
$sql = "SELECT lastrun, auditname FROM audits.auditslist WHERE auditcode='$thisaudit' LIMIT 1";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
$row = $result->fetch_assoc();
$lastrun=$row["lastrun"];
$thisauditname=$row["auditname"];

$pagetitle= 'Audits -- ' . $thisauditname;
//set mod to select vwbar options
include "$rwarepath/navs/topsimplenav.php";
$baseurl="audits/audits.php?";
//navbar
?>
<p>
<?php
$sql = "SELECT auditcode, auditname FROM audits.auditslist";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
while($row = $result->fetch_assoc())
	{
	$auditcode=$row["auditcode"];
	$auditname=$row["auditname"];
	$tab='<a href="' . $baseurl . '&amp;audit=' . $auditcode . '">' . $auditname . '</a>';
		$color = ($auditcode==$thisaudit) ? "red" : "#333" ;
		echo '<a class="ui-state-default" style="color: '.$color.';" href="' . $baseurl . '&amp;audit=' . $auditcode . '">' . $auditname . '</a>&nbsp;&nbsp;';
	}
	echo "</p>";
include('../../krulocal/audits2/' . $thisaudit . '.php');
include '../parts/footer.php';
?>