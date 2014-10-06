<?php
//--Wed Aug  6 14:13:44 EDT 2014--
include realpath($_SERVER['DOCUMENT_ROOT'].'/').'../../tmp/renalwareconn.php';
include '../req/confcheckfxns.php';
//config lists
$listslist = array(
	'currentlist' => "Current ESRF Pats",
);
$thislistgroupname = "ESRF Patient List";
$thislist = ($get_list) ? $get_list : "currentlist";
$thislistname=$listslist["$thislist"];
$thislistfolder="esrflists";
$thislistbase="esrflist";
$listitems="ESRF patients";
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
//	echo '<button style="color: green;" onclick="$(\'#addformdiv\').toggle()">Add Lupus patient</button>';
	echo '</div>
<div id="datatablediv">';
include("$thislistfolder/$thislist.php");
echo '</div>';
include '../parts/footer.php';
