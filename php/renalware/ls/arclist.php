<?php
//--Thu Nov  1 11:44:19 CET 2012-- DT upgrade
include realpath($_SERVER['DOCUMENT_ROOT'].'/').'../../tmp/renalwareconn.php';
include '../req/confcheckfxns.php';
//config lists
$listslist = array(
	'activelist' => "Current ARC Pats",
	'goldreglist' => "Gold Register List",
);
$thislistgroupname = "Advanced Renal Care Patient List";
$thislist = ($get_list) ? $get_list : "activelist";
$thislistname=$listslist["$thislist"];
$thislistfolder="arclists";
$thislistbase="arclist";
$listitems="ARC patients";
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
