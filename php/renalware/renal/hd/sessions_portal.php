<?php
//----Mon 25 Feb 2013----streamlined
//Tue May 12 08:32:11 BST 2009
//-------------------------------start formstuff-------------------------------
if (isset($_GET['updatesess']))
	{
	include "$rwarepath/renal/hd/run/runupdatesession.php";
	} // end update IF
echo '<div id="hdsessionform" style="display:none; padding-top:0px;font-size: 12px;">
	<form action="renal/renal.php?zid='.$zid.'&amp;scr=hdnav&amp;hdmode=sessionlist&amp;add=hdsession" method="post">';
	include "$rwarepath/renal/hd/hdsession_fieldset.php"; 
    echo '</form>
</div>';
//----Fri 02 Jul 2010----DEPRECATED delete function
//get total no
$sql= "SELECT hdsession_id FROM hdsessiondata WHERE hdsesszid=$zid";
$result = $mysqli->query($sql);
$totalnum = $result->num_rows;
//LIMIT--get from parent page or here
$descr = "HD sessions recorded";
$fields = "*, DATE_FORMAT(hdsessdate, '%a %d-%m-%y') as hdsessdate_ddmy";
$table = "hdsessiondata";
$where="WHERE hdsesszid=$zid";
$order="ORDER BY hdsessdate DESC";
$limit="LIMIT $sesslimit";
$sql= "SELECT $fields FROM $table $where $order $limit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo '<p class="header">There are '. "$totalnum $descr". ' for this HD patient ('.$numrows.' displayed). &nbsp; &nbsp; <button class="ui-state-default" style="color: green;" onclick=\'$("#hdsessionform").toggle();\'>add new HD Session</button></p>';
include "$rwarepath/renal/hd/updatesessionstable_incl.php";
