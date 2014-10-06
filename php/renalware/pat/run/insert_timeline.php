<?php
//--Mon Feb 25 17:09:36 GMT 2013--
//nb requires upstream setting of $uid, '$user','$timelinecode', $zid, '$timelineadddate', '$timelinedescr', '$timelinetext'
$insertfields="timelineuid, timelineuser, timelinecode, timelinezid, timelineadddate, timelinedescr, timelinetext";
if ($timelineadddate) {
    $values="$uid, '$user','$timelinecode', $zid, '$timelineadddate', '$timelinedescr', '$timelinetext'";
} else {
    $values="$uid, '$user','$timelinecode', $zid, CURDATE(), '$timelinedescr', '$timelinetext'";
}
$table = "timelinedata";
$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
//log the event
$eventtype="NEW TIMELINE: $timelinecode -- $timelinedescr";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
//end logging
