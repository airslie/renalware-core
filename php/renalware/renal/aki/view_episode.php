<?php
//----Fri 20 Dec 2013----handle via consultid ----Mon 06 Jan 2014----DEPR
//----Tue 05 Mar 2013----
//get latest AKI episode data unless GET show=id
    $thisid=(int)$get_id;
    $sql = "SELECT * FROM akidata WHERE aki_id=$thisid";
    $showlabel="View AKI Episode $thisid";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
$row = $result->fetch_assoc();
foreach ($row as $key => $value) {
	$$key = (substr($key,-4)=="date") ? dmy($value) : $value ;
	}
//display latest
echo "<h3>$showlabel: $episodedate</h3>";
include 'aki/incl_akinav.php';
echo '<div id="episodeviewdiv">';
//display episode data using config array
$showfields=$showakifields;
include 'incl/showfields2ul.php';
echo '</div>
</div>';
