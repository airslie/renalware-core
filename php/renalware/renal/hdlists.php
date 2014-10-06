<?php
//Sun May 10 14:20:49 CEST 2009
//set subnav items
$hdlistsnav = array (
	'hdpatlist' => 'HD Pats List',
	'patprefslist' => 'Pat Prefs List',
	'editpatprefs' => 'Update Prefs',
	'siteslist' => 'Sites List',
	'sitescheds' => "Site Scheds",
	'holslist' => "Holidays List"
	);
$list = ($_GET['list']) ? $_GET['list'] : "hdpatlist" ;
$listdir='hd';
$pagetitle="$siteshort HD: {$hdlistsnav[$list]}";
include '../req/confcheckfxns.php';
include "$rwarepath/navs/topsimplenav.php";
echo '<div class="buttonsdiv">';
	foreach ($hdlistsnav as $key => $value) {
		$color = ($key==$list) ? "red" : "#333" ;
		echo '<a style="color: '.$color.';" href="renal/hdlists.php?list=' . $key . '">' . $value . '</a>';
	}
echo '</div>';
//get list page
include("$listdir/$list.php");
include '../parts/footer.php';
?>