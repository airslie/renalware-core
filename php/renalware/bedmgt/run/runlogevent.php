<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
ob_start();
session_start();
$user=$_SESSION['user'];;
$uid=$_SESSION['uid'];
require '/var/conns/bedmgtconn.php';
$mysqli->select_db("bedmgt");
//process SUBMIT
if ( $pid )
{
$type="
$proced-- priority: $priority; status: $status; listed: $listeddate; TCI: $tcidate at $tcitime; preop: $preopdate at $preoptime; surgdate: $surgdate slot: $surgslot";
}
$insertfields="logstamp, user, uid, pid, eventzid, type, eventtext";
$values="NOW(), '$user', $uid, $pid, '$pzid', '$type', '$eventtext'";
$table = "bedmgtlogs";
$sql="INSERT INTO $table ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
?>