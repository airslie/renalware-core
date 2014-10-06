<?php
//----Sat 10 Nov 2012----confirm add pat version
//--Sat Oct  6 19:39:29 JST 2012--NEW to New
//--Tue Sep  4 14:21:12 CEST 2012--
include '/var/conns/renalwareconn.php';
include '../req/confcheckfxns.php';
//config lists
$listslist = array(
	'activelist' => "All Current",
);
$thislistgroupname = "Renal Patient View List";
$thislist = ($get_list) ? $get_list : "activelist";
$thislistname=$listslist["$thislist"];
$thislistfolder="rpvlists";
$thislistbase="rpvlist";
$listitems="RPV patients";
$pagetitle= $thislistgroupname . ' -- ' . $thislistname;
// --------- ----Mon 10 Oct 2011---- SHOULD NOT NEED TO MODIFY BELOW -------------------
//get datatable header
include '../parts/head_datatbl.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
//----Sat 10 Nov 2012----confirmable version
if ($get_newzid) {
    $newzid=(int)$get_newzid;
	echo '<p><a class="btn" style="color: green; border: 1px solid black; padding: 3px;" href="ls/rpvlist.php?confirmzid='.$newzid.'">Confirm you wish to add to RPV</a>&nbsp;&nbsp;<a class="btn" style="color: #f00;" href="ls/rpvlist.php">Cancel</a></p>';
    
}
//----Tue 04 Sep 2012----to add new pat to RPV NB "NEW" only
if ($get_confirmzid) {
    $thiszid=(int)$get_confirmzid;
    $sql = "UPDATE patientdata SET rpvstatus='New', rpvuser='$sess_user', rpvmodifstamp=NOW(),lasteventuser='$sess_user', lasteventstamp=NOW(), lasteventdate=CURDATE() WHERE patzid=$thiszid LIMIT 1";
    $result = $mysqli->query($sql);
    echo '<p class="alert">Your patient has been added to the RPV!</p>';
}
//navbar
echo '<div class="buttonsdiv">';
foreach ($listslist as $list => $listname) {
	$class = ($thislist==$list) ? 'class="hilit"' : "" ;
	echo "<button $class onclick=\"location.href='ls/$thislistbase.php?list=$list'\">$listname</button>&nbsp;&nbsp;";
	}
	echo '</div>
<div id="datatablediv">';
include("$thislistfolder/$thislist.php");
echo '</div>';
include '../parts/footer.php';
