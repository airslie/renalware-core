<?php
//----Mon 25 Feb 2013----streamlining
//get data for pat **already uppage now if HDflag=1
//include "$rwarepath/data/hddata.php";
include('hd/siteoptions_incl.php');
//set default for HD sessions display
$sesslimit=100; //default for history display
//set subnav items
$hdmodes = array (
'profile' => 'HD Profile',
'scrollprofiles' => "Scroll $currsite Profiles",
'updateprofileform' => 'Update Profile',
'sessionlist' => "View/Edit Sessions",
'prefshols' => 'Prefs/Hols',
'hdscreen' => 'HD Screen'
);
$hdmode = ($get_hdmode) ? $get_hdmode : "profile" ;
echo '<div class="buttonsdiv">';
foreach ($hdmodes as $key => $value) {
	$color = ($key==$hdmode) ? "red" : "#333" ;
	echo '<a style="color: '.$color.';" href="renal/renal.php?zid=' . $zid . '&amp;scr=hdnav&amp;hdmode=' . $key . '">' . $value . '</a>&nbsp;&nbsp;';
	}
echo '<a style="color: purple;" href="renal/hd/printhdprofiles.php?zid='.$zid.'" >Print HD Profile</a>&nbsp;&nbsp;';
$patinfoURL='renal/patient_info/printHDsheets.php?zid=' . $zid;
echo '<a style="color: green;" href="' . $patinfoURL . '"  target="_blank" onclick="window.open(\'' . $patinfoURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">Print Pat HD Info</a>&nbsp;';
    echo '</div>';
//get mode page
include("hd/$hdmode.php");
