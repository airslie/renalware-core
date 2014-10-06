<?php
include '/var/conns/renalwareconn.php';
include '../req/confcheckfxns.php';
//config lists
$listslist = array(
	'esacurrent' => "Current ESA Pats",
	'esachanges' => "All Changes (last 30d)",
	'esaterms' => "ESA Terms (last 30d)",
	'esaadds' => "New ESA Rx (last 30d)",
	'esahomedelivery' => "Curr Home Deliveries",
	'esahomedelivchanges' => "Home Deliv Changes",
	);
$thislistgroupname = "ESA Lists";
$thislist = ($get_list) ? $get_list : "esachanges";
$thislistname=$listslist["$thislist"];
$thislistfolder="esalists";
$thislistbase="esalists";
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