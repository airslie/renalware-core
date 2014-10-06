<?php
include '../incl/required_incl.php';
	$mysqli->select_db("$post_thisdb");
	$filename=str_replace(" ","_",$post_pagetitle);
	$zone=3600*-5;//US
	$filedate=gmdate("ymd_Hi", time() + $zone);
	$filenamedate =$filename . '_' . $filedate;
	$result = $mysqli->query($post_thissql);
	$numfound=$result->num_rows;
	$numfields=$result->field_count;
	$fieldnames = $result->fetch_fields();
	header("Content-type: application/octet-stream"); 
	header("Content-Disposition: attachment; filename=$filenamedate.$post_filetype"); 
	header("Pragma: no-cache"); 
	header("Expires: 0");
	foreach ($fieldnames as $val) {
	    printf("%s\t", $val->name);
	} 
	echo "\n";
	while($row = $result->fetch_row())
		{
		for ( $i=0; $i < $numfields; $i++ )
			{ 
			echo $row["$i"] . "\t";
			}
		echo "\n";
		}
	echo "\n\n$numfound rows ($numfields fields) generated for $username at " . date("D j M Y  G:i:s");
	echo "\n\nYour query was: " . $post_thissql . "\n on database $db";
//  	header ("Location: ../$post_goto");
?>