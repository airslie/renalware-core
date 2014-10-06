<?php
//----Sun 28 Oct 2012----streamlining
require '../config_incl.php';
require '../incl/check.php';
include '../fxns/fxns.php';
include '../fxns/formfxns.php';
$debug = ($get_debug) ? TRUE : FALSE ;
//defaults
$scr = ($get_scr) ? $get_scr : "renalsumm" ;
//get patientdata
$zid=(int)$get_zid;
include "$rwarepath/data/patientdata.php";
include "$rwarepath/data/probs_meds.php";
include "$rwarepath/data/renaldata.php";
if ($esdflag) {
    include "$rwarepath/data/esddata.php";
	}
//some updates here ----Tue 22 Jun 2010----
if ( $_GET['update']=='height' )
	{
	//insert new data
	$newheight = $mysqli->real_escape_string($_POST["newheight"]);
	$newheightdate = $mysqli->real_escape_string($_POST["newheightdate"]);
	$newheightdate=fixDate($newheightdate);
	//try validation
	if ( $newheight>2 or $newheight=='')
    	{
    		echo "Please check your data entry and try again";
    	}
	else
    	{
    	//update currentclindata
    	$BMI=round($Weight/$newheight/$newheight,1);
    	$updatefields = "currentadddate=NOW(), Height='$newheight', Heightdate='$newheightdate', BMI='$BMI'";
    	$tables = 'currentclindata';
    	$where = "WHERE currentclinzid=$zid";
    	$sql = "UPDATE $tables SET $updatefields $where LIMIT 1";
    	$result = $mysqli->query($sql);
    	//log the event
    	$eventtype="NEW Height DATA ADDED = $newheight meters; BMI=$BMI";
    	$eventtext=$mysqli->real_escape_string($sql);
    	include "$rwarepath/run/logevent.php";
    	//end logging
    	}
	}
include "$rwarepath/data/currentclindata.php"; //nb may be updated above
$pagetitle= ($zid) ? strtoupper($scr).':&nbsp;&nbsp;' . $titlestring : strtoupper($scr);
//get header
include '../parts/head.php';
//hide main navbar if menu=hide
$win = (isset($get_win)) ? $get_win : FALSE ;
$menu = (isset($get_menu)) ? $get_menu : FALSE ;
if ($win=="new") {
	//only display if new window
	echo '<input type="button" class="ui-state-default" style="color: red;" value="Close Window" onclick="javascript:window.close();"/><br>';
}
if ($menu!="hide") {
	include '../navs/mainnav.php';
	}
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
include '../navs/patnavarray.php';
include '../navs/renalnav.php';
include '../navs/clinpathdiv.php' ;
include '../navs/allergiesdiv.php';
//end array nav
include $scr . '.php';
include '../parts/footer.php';
