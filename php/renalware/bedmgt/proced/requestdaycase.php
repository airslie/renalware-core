<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//
if ( $_GET['zid'] or $_GET['hospno'])
{
	if ($_GET['zid'])
		{
		$zid=(int)$_GET['zid'];
		include( 'newdaycaseform.php' );	
		}
	if ($_GET['hospno'])
		{
		//get zid
		$hospno=strtoupper($_GET['hospno']);
		$sql="SELECT patzid FROM renalware.patientdata WHERE hospno1='$hospno' LIMIT 1";
		$result = $mysqli->query($sql);
		$row = $result->fetch_assoc();
		$numfound=$result->num_rows;
		if ( !$numfound )
			{
			echo "Sorry $hospno could not be located. Please try again.<br>";
			include( 'enterreqhospno.php' );
			}
		else
			{
			$zid=$row["patzid"];
			include( 'newdaycaseform.php' );	
			}
		}
}
else
{
	include( 'enterreqhospno.php' );
}
?>