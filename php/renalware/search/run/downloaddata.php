<?php
//created on Sun Sep  7 17:50:58 BST 2008
//-----------------start required includes---------------------------
require '../../incl/check.php';
//paths
$searchurl="http://renalweb/renalware/search";
$searchpath="/Library/Webserver/Documents/renalweb/renalware/search";
$connpath="/var/conns";
//reqs
include "$searchpath/req/fxns.php";
//$newfilenameraw = $mysqli->real_escape_string($_POST["newfilename"]);
//$newfilename=str_replace(" ","_",$newfilenameraw);
$newfilename=str_replace(" ","_",$post_newfilename);
//$sql=$_POST['runsql'];
$sql=$post_runsql;
$sql=str_replace("\'","'",$sql); // b/c escaped post
//handle header
$contenttype = ($post_filetype=="xls") ? "octet-stream" : "text/plain" ;
header("Content-type: application/octet-stream"); 
header("Content-Disposition: attachment; filename=\"$newfilename.$post_filetype\""); 
header("Pragma: no-cache"); 
header("Expires: -1"); 

$result = $mysqli->query($sql);
$numrows=$result->num_rows;
$finfo = $result->fetch_fields();
//handle CSV vs TXT/XLS
if ($post_filetype=="csv") {
    foreach ($finfo as $val) {
            printf("\"%s\",", $val->name);
    } 
    echo "\n";
    while($row = $result->fetch_assoc())
    	{
    	foreach ($row as $key => $value)
    	    {
    		echo '"'.htmlspecialchars_decode($value, ENT_QUOTES) . '",';
    	    }
    	echo "\n";
    	}
} else {
    foreach ($finfo as $val) {
            printf("%s\t", $val->name);
    } 
    echo "\n";
    while($row = $result->fetch_assoc())
    	{
    	foreach ($row as $key => $value)
    	    {
    		echo htmlspecialchars_decode($value, ENT_QUOTES) . "\t";
    	    }
    	echo "\n";
    	}
}
echo "\n\n$numrows rows generated at " . date("D j M Y  G:i:s") . "  by your query";
?>