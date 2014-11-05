<?php
//----Fri 22 Nov 2013----not logged in redirect fix
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
ob_start();
session_start();
if (isset($_SESSION['user']))
	{
	$user=$_SESSION['user'];
	$uid=$_SESSION['uid'];
	$bedmgrflag=$_SESSION['bedmgrflag'];
	} 
	else {
	//not logged in
    header ("Location: ../login.php");
	}
//incl datestuff,options
include( 'incl/settings.php' );
include( 'incl/datestuff.php' );
include( 'incl/fxns.php' );
include( 'nav/vwslist.php' );
require '/var/conns/bedmgtconn.php';
//include( 'options/optionsarray.php' );
//defaults
$vw = ($get_vw) ? $get_vw : 'user' ;
$mode = ($get_mode) ? $get_mode : 'view' ;
$pid = ($get_pid) ? $get_pid : FALSE ;
$pagetitle = ($vw=="letter") ? "KRU Bed Management Letter" : $vwslist[$vw] ;
$scr=$_GET['scr'];
if ($pid) {
	include( 'proced/getproceddata_incl.php' );
}
//get appropr header
include( 'parts/' . $mode . 'header.html' );
if ($mode!='letter')
	{
	echo "<div id=\"headerdiv\"><h1><span class=\"red\">Renalware -- Bed Management System</span>&nbsp;&nbsp;$pagetitle</h1></div>";
	}
if ($mode=='view')
	{
	//navbar
	echo '<div id="navsdiv">
	<ul class="primary">';
	echo '<li><a href="../lists/patientlist.php">Renalware</a></li>';
	foreach ($vwsnav as $key => $value) {
		//parse
		$vwscr = explode("&", $key);
		$vwpair = explode("=", $vwscr[0]);
		$navvw=$vwpair[1];
		$tab='<li><a href="index.php?' . $key . '">' . $value . '</a></li>';
		if ( $navvw==$vw )
			{
			$tab='<li class="active"><a href="index.php?' . $key . '" class="active">' . $value . '</a></li>';
			}
		echo "$tab";
		}
	//print option
	$hostname=$_SERVER['HTTP_HOST'];
echo '<li><a href="http://' . $hostname . htmlentities($_SERVER['REQUEST_URI']) . '&amp;mode=print" title="print mode" >Print Screen</a></li>'; 
	echo "</ul>";
	include('nav/' . $vw . '.php');
	//get name from k=v array
	$thisquery=$_SERVER['QUERY_STRING'];
	//show subnav
	echo '<ul class="subnav">';
	foreach ($scrs as $key => $value) {
		$navkey=$key;
		$tab='<li><a href="index.php?' . $key . '">' . $value . '</a></li>';
		if ( $navkey==$thisquery )
			{
			$tab='<li class="active"><a href="index.php?' . $key . '" class="active">' . $value . '</a></li>';
			}
		echo "$tab";
		}
		if ($bedmgrflag=='1') {
		 echo '<li><a href="index.php?vw=proced&amp;scr=requestsurgcase">Request New Surg Proced</a></li>';
//		 echo '<li><a href="index.php?vw=proced&amp;scr=requestdaysurgcase">Request New Day Surg Case</a></li>';
		}
	echo "</ul>";
	//add FINDDAY searchbar
	include( 'incl/searchbar.php' );
	}
	//end subnav
	//end navs
	echo "</div>";
//get screen
echo '<div id="screendiv">';
include( $vw . '/' . $scr . '.php' );
echo '</div>';
