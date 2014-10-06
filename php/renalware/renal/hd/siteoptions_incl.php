<?php
//create easy sitelist
$sql="SELECT sitecode FROM sitelist";
$result = $mysqli->query($sql);
$siteoptions=""; //start
while($row = $result->fetch_row()) {
 $siteoptions.= '<option>' . $row['0'] . "</option>\n";
}
//for guys options... bah humbug!
$guyssiteoptions="";
$guyssites = array(
'Forest Hill',
'New Cross',
'Pembury',
'Guy&rsquo;s Satell',
'Guy&rsquo;s Bostock',
'Other'
);
foreach ($guyssites as $key => $value) {
	$guyssiteoptions .= "<option>$value</option>\n";
}
$prefsiteoptions="$siteoptions\n$guyssiteoptions";

?>