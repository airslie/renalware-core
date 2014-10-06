<?php
//----Mon 15 Oct 2012----streamlining
require '../fxns/fxns.php';
//Tue Sep 15 10:55:07 BRT 2009 improved stages
$navitems=array(
	'index.php'=>'Start',
	'preflight.php'=>'Preflight (check data)',
	'selectquarter.php'=>'Select Quarter',
	);
$thisqtr=$_SESSION['sessqtr'];
$thisstartdate=$_SESSION['sessstartdate'];
$thisenddate=$_SESSION['sessenddate'];
$debug=$_GET['debug'];
if ($thisqtr) {
	$pagetitle.=" <b>Quarter $thisqtr</b>";
	$navitems=array(
		'index.php'=>'Start',
		'preflight.php'=>'Preflight (check data)',
		'selectquarter.php'=>'Change Quarter',
		'preppathology.php'=>'Prep Path Data (slow)',
		'prepquarter.php'=>'Prep Patient Data',
		'runquarter.php'=>"Run Quarter $thisqtr ($thisstartdate --> $thisenddate)",
		);
}
echo '<div class="navbar navbar-fixed-top">
	  <div class="navbar-inner">
	    <div class="container">
	<a class="brand" href="renalreg/index.php">Renal Reg</a>
<ul class="nav">
	<li><a style="color: red;" href="user/userhome.php">Renalware</a></li>';
foreach ($navitems as $linktab => $linklabel) {
	$li = ($linktab==$thistab) ? '<li class="active">' : '<li>' ;
    if ($thisqtr) {
    	echo $li.'<a href="renalreg/'.$linktab.'?qtr='.$thisqtr.'&amp;debug='.$debug.'">'."$linklabel</a></li>";
    } else {
    	echo $li.'<a href="renalreg/'.$linktab.'">'."$linklabel</a></li>";
    }
	}
echo '</ul>
	    </div>
	  </div>
	</div>
<div class="container">';
