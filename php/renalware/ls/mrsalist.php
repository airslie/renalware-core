<?php
//----Mon 16 May 2011----
include realpath($_SERVER['DOCUMENT_ROOT']).'/renalwareconn.php';
include '../req/confcheckfxns.php';
//config lists
$listslist = array(
	'swablist' => "All Swabs",
	'poslist' => "Positive Swabs",
	'noresultlist' => "Swabs without results",
	);
$thislistgroupname = "MRSA Swabs List";
$thislist = ($get_list) ? $get_list : "swablist";
$thislistname=$listslist["$thislist"];
$thislistfolder="mrsalists";
$thislistbase="mrsalist";
$pagetitle= $thislistgroupname . ' -- ' . $thislistname;
// --------- ----Mon 10 Oct 2011---- SHOULD NOT NEED TO MODIFY BELOW -------------------
//get datatable header
include '../parts/head_datatbl.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
//navbar
echo '<div class="buttonsdiv">';
foreach ($listslist as $list => $listname) {
	$class = ($thislist==$list) ? 'class="hilit"' : "" ;
	echo "<button $class onclick=\"location.href='ls/$thislistbase.php?list=$list'\">$listname</button>&nbsp;&nbsp;";
	}
	echo "</div>";
include("$thislistfolder/$thislist.php");
include '../parts/footer.php';
?>