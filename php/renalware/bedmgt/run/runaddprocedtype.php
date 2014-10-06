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
$proced = $mysqli->real_escape_string($_POST["proced"]);
$category = $_POST["category"];
$insertfields="proced, category, addstamp, modifstamp, add_uid";
$values="'$proced','$category', NOW(),NOW(), $uid";
$table = "procedtypes";
$sql="INSERT INTO $table ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
$pid=NULL;
$type="Procedure $proced ($category) ADDED by $user";
$notes="$proced";
$eventtext=$mysqli->real_escape_string($values);;
include( 'runlogevent.php' );
header ("Location: ../index.php?vw=user&scr=fixprocedslist");
