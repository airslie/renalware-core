<?php
//----Tue 11 Jun 2013----datatable upgrade
include realpath($_SERVER['DOCUMENT_ROOT']).'/../../tmp/renalwareconn.php';
include '../req/confcheckfxns.php';
$showsql=false;
//config lists
$listslist = array(
	'usercurrent' => "$user Drafts/Typed",
	'sitedrafts' => "All Drafts",
	'sitelastday' => "All Letters (prev day)",
	'sitelastweek' => "All Letters (prev wk)",
	'siteprintqueue' => "Print Queue (Incl non-email GPs)",
	'sitegpemailqueue' => "Print Queue (Incl email GPs)",
	);
$thislistgroupname = "Letters lists";
$thislist = ($get_list) ? $get_list : "usercurrent";
$thislistname=$listslist["$thislist"];
$thislistfolder="letterslists";
$thislistbase="letterslists";
$listitems="letters";
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
echo '</div>
<div id="datatablediv">';
include("letterslists/$thislist.php");
echo '</div>';
include '../parts/footer.php';
