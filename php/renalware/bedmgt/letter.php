<?php
//--Mon Aug 27 15:14:43 JST 2012--for enhanced letterheads
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
	$pagetitle="Please Log In";
	include '../parts/footer_login.php';
	echo "<p>Please log in to Renalware to use the Renal Bed Manager</p>";
	include 'incl/footer.php';
	}
//incl datestuff,options
include 'incl/settings.php';
include 'incl/datestuff.php';
include 'incl/fxns.php';
require '/var/conns/bedmgtconn.php';
//defaults
$pid = (int)$get_pid;
$pagetitle = "KRU Bed Management Letter";
include 'proced/getproceddata_incl.php';
include "../parts/head_letter.php";
include 'letter/lettertypes_incl.php';
$lettername=$lettertypes[$get_type];
$letterdate=Date("d/m/Y");
$pagetitle="&ldquo;$lettername&rdquo; for $proced (ID #$pid)";
//make letterhead
$lettersite='KCH'; //default
$sql = "SELECT * FROM renalware.letterheadlist WHERE sitecode='$lettersite' LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$unitinfo=$row["unitinfo"];
$trustname=$row["trustname"];
$trustcaption=$row["trustcaption"];
$siteinfohtml=$row["siteinfohtml"];
echo '<div id="letterhead">
	<div id="topleft">
	<p id="renalunit">RENAL ADMISSIONS DEPARTMENT</p>
	<p id="header">'.$todayDayMonYear . "<br>
        Hospital No. $hospno";
		echo "<br><br><br>PRIVATE AND CONFIDENTIAL<br>            
            <br><br><br><br>
            $title $firstnames $lastname <br>
            $addr1 <br>
            $addr2 <br>
            $addr3 $addr4 $postcode
            <br><br><br>
	</div>";
	echo '<div id="topright">
		<span id="trustname">'.$trustname.'</span> <span id="nhslogo">NHS</span><br>
		<span id="trustcaption">'.$trustcaption.'</span><br>
		<div class="siteinfohtml">'.$siteinfohtml.'</div>
	</div>
</div>
<div style="clear: both;">';
include "letter/$get_type.php";
echo '</div>';
?>
<script type='text/javascript'>
<!--
   var w = 800;
   var h = 600;
   resizeTo(w, h);
   moveTo(50, 20);
//-->
</script>