<?php
//----Sun 07 Apr 2013----NB does not include Add Op function
//--Sun Apr  7 15:05:35 CEST 2013--
include realpath($_SERVER['DOCUMENT_ROOT']).'/../../tmp/renalwareconn.php';
include '../req/confcheckfxns.php';
//config lists
$listslist = array(
	'alloplist' => "All Tx Ops",
);
$thislistgroupname = "Tx Ops Module";
$thislist = ($get_list) ? $get_list : "alloplist";
$thislistname=$listslist["$thislist"];
$thislistfolder="txoplists";
$thislistbase="txoplist";
$listitems="Transplant Ops";
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
//	echo '<button style="color: green;" onclick="$(\'#addformdiv\').toggle()">Add Tx Op Patient</button>';
	echo '</div>
<div id="datatablediv">';
include("$thislistfolder/$thislist.php");
echo '</div>';
include '../parts/footer.php';
?>
