<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
ob_start();
session_start();
$user=$_SESSION['user'];;
$uid=$_SESSION['uid'];
//for devel
$user='pna';
$uid=1;
$loginflag=1;
require '/var/conns/bedmgtconn.php';
$mysqli->select_db("bedmgt");
//process SUBMIT
$surgfirst = $mysqli->real_escape_string($_POST["surgfirst"]);
$surglast = $mysqli->real_escape_string($_POST["surglast"]);
$surgemail = $mysqli->real_escape_string($_POST["surgemail"]);

$insertfields="surgfirst, surglast, surgemail, addstamp, modifstamp, add_uid";
$values="'$surgfirst', '$surglast', '$surgemail', NOW(),NOW(), $uid";
$table = "surgeons";
$sql="INSERT INTO $table ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
//log
$pid=NULL;
$type="Surgeon ADDED";
$notes="$surgfirst $surglast";
$eventtext="$insertfields";
include( 'runlogevent.php' );
header ("Location: ../index.php?vw=surg&scr=addsurgeon");
