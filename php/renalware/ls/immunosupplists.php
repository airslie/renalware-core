<?php
//--Mon Jul 29 16:43:17 EDT 2013--
include '/Users/lat/projects/renalwarev2/tmp/renalwareconn.php';
include '../req/confcheckfxns.php';
//config lists
$listslist = array(
	'immunosuppchanges' => "All Changes (last 30d)",
	'recenthosp' => "Hosp Delivery Changes (last 30d)",
	'recenthosphome' => "Hosp Home Delivery Changes (last 30d)",
);
$thislistgroupname = "Immunosuppression Lists";
$thislist = ($get_list) ? $get_list : "immunosuppchanges";
$thislistname=$listslist["$thislist"];
$thislistfolder="immunosupplists";
$thislistbase="immunosupplists";
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
