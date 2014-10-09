<?php
//--Fri Oct 26 15:45:21 SGT 2012--
include realpath($_SERVER['DOCUMENT_ROOT']).'/../../tmp/renalwareconn.php';
include '../req/confcheckfxns.php';
//config lists
$listslist = array(
	'activelist' => "Current Lupus Pats",
);
$thislistgroupname = "Renal Lupus Patient List";
$thislist = ($get_list) ? $get_list : "activelist";
$thislistname=$listslist["$thislist"];
$thislistfolder="lupuslists";
$thislistbase="lupuslist";
$listitems="Lupus patients";
$pagetitle= $thislistgroupname . ' -- ' . $thislistname;
// --------- ----Mon 10 Oct 2011---- SHOULD NOT NEED TO MODIFY BELOW -------------------
//get datatable header
include '../parts/head_datatbl.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
if ($get_newzid) {
    $newzid=(int)$get_newzid;
    $sql = "INSERT INTO lupusdata (lupusuid,lupususer,lupuszid,lupusadddate) VALUES ($sess_uid, '$sess_user',$newzid,CURDATE())";
    $result = $mysqli->query($sql);
    $sql = "UPDATE renaldata SET lupusflag='Y',renalmodifstamp=NOW() WHERE renalzid=$newzid LIMIT 1";
    $result = $mysqli->query($sql);
    $sql = "UPDATE patientdata SET lasteventstamp=NOW(),lasteventdate=CURDATE(),lasteventuser='$sess_user' WHERE patzid=$newzid LIMIT 1";
    $result = $mysqli->query($sql);
    echo '<p class="alert">Your patient has been added to the Lupus list!</p>';
}
//navbar
echo '<div class="buttonsdiv">';
foreach ($listslist as $list => $listname) {
	$class = ($thislist==$list) ? 'class="hilit"' : "" ;
	echo "<button $class onclick=\"location.href='ls/$thislistbase.php?list=$list'\">$listname</button>&nbsp;&nbsp;";
	}
	echo '<button style="color: green;" onclick="$(\'#addformdiv\').toggle()">Add Lupus patient</button>';
	echo '</div>
	<div id="addformdiv" style="display: none;">
		<h3>Step 1: Find desired patient</h3>
	<form name="searchpatdata" id="searchpatdata">
		<fieldset>
			<legend>Enter patient hospital number</legend>
	<label>Enter KCH Hosp No then TAB:</label>
	<input type="text" onchange="findHospNo();" id="ajaxhospno"/><input type="button" onclick="findHospNo()" value="Search Patients" /><br><br>
	</fieldset></form><br>
	<div id="searchresultsdiv"></div>
	</div>
<div id="datatablediv">';
include("$thislistfolder/$thislist.php");
echo '</div>';
include '../parts/footer.php';
?>
<script charset="utf-8">
function findHospNo(this_id){
	$('#datatablediv').hide();
	var ajaxhospno=$('#ajaxhospno').val();
	$.get("ajax/run-getlupuslistpat.php", {hospno: ajaxhospno},
	   function(data){
		$('#searchresultsdiv').html(data);
		});
	}
</script>