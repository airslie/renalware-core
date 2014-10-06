<?php
//Wed Oct 22 16:44:25 IST 2008
include realpath($_SERVER['DOCUMENT_ROOT'].'/').'../../tmp/renalwareconn.php';
include '../req/confcheckfxns.php';
//config lists
$listslist = array(
	'activelist' => "Active Patients",
	'suspendedlist' => "Suspended Patients",
	'waitlist' => "Active &amp; Suspended List",
	'workinguplist' => "&ldquo;Working Up&rdquo; List",
	'nhblist' => "&ldquo;NHB Consent&rdquo; List",
	);
$thislistgroupcode="txwaitlists"; //for e.g. "esdsearch" in complexsearch
$thislistgroupname = "Tx Wait List";
$thislistcode = ($get_list) ? $get_list : "activelist";
$thislistname=$listslist["$thislistcode"];
//set header
if (substr($thislistcode,-6)=="search") {
	$thislistname="Complex Search";
}
$pagetitle= $thislistgroupname . ' -- ' . $thislistname;
//set mod to select vwbar options
//get header
include '../parts/head.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
$baseurl="ls/txwaitlist.php";
//navbar
echo '<p>';
foreach ($listslist as $listcode => $listname)
	{
	$style = ($listcode==$thislistcode) ? "color: red; background: yellow" : "color: #333" ;
	echo '<a class="ui-state-default" style="'.$style.'" href="' . $baseurl . '?list=' . $listcode . '">' . $listname . '</a>&nbsp;&nbsp;';
	}
	//for search
	echo '<a class="ui-state-default" style="color: purple;" onclick="$(\'#listsearchdiv\').toggle()">Quick Search</a>';
	echo "</p>";
include('txwaitlists/' . $thislistcode . '.php');
include '../parts/footer.php';
?>