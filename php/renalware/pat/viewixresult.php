<?php
include '../req/confcheckfxns.php';
//get patientdata
$zid = $_GET['zid'];
$ixworkupdata_id = $_GET['ixworkupdata_id'];
$fields = "lastname, firstnames, hospno1, ixworkupdata_id, ixworkupuser, ixworkupzid, ixworkupmodal, ixworkupdate, ixworkuptype, ixworkupresults, ixworkuptext";
$tables = "ixworkupdata LEFT JOIN patientdata ON ixworkupzid=patzid";
$where = "WHERE ixworkupdata_id=$ixworkupdata_id";
$sql= "SELECT $fields FROM $tables $where";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$lastname=$row["lastname"];
$firstnames=$row["firstnames"];
$hospno1=$row["hospno1"];
$ixworkupuser=$row["ixworkupuser"];
$ixworkupmodal=$row["ixworkupmodal"];
$ixworkupdate=dmy($row["ixworkupdate"]);
$ixworkuptype=$row["ixworkuptype"];
$ixworkupresults=$row["ixworkupresults"];
$ixworkuptext=$row["ixworkuptext"];
$pagetitle= "$ixworkuptype Result for " . $firstnames . ' ' . strtoupper($lastname);
include '../parts/head_focus.php';
?>
<h3><?php echo $pagetitle; ?></h3>
<?php
	echo '<p class="alertsmall">' . strtoupper($ixworkuptype) . '</p>
	<p style="width: 400px">' . 
	"<i>date: </i><b>$ixworkupdate</b><br>" . 
	'<i>' . $ixworkupresults . '</i><br><br>' . $ixworkuptext . '</p>';
?>
</body>
</html>