<?php
//----Mon 27 Aug 2012---- DEPR as security policy precludes XLS
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//for copyright info see renalbedmgt_info.php 2007 Paul Nordstrom August
// ob_start();
// session_start();
// $xlsquery=$_SESSION['xlsquery'];
// $xlsmodule=$_SESSION['xlsmodule'];
// $xlsname='KRUbedmgt-' . $_SESSION['xlsname'];
// $user=$_SESSION['user'];
// require '/var/conns/bedmgtconn.php';
$mysqli->select_db("bedmgt");
// $zone=3600*-0;//UK
// $xlsdate=gmdate("ymd_Hi", time() + $zone);
// $xlsname=$xlsname . '_' . $xlsdate;
// header("Content-type: application/octet-stream"); 
// header("Content-Disposition: attachment; filename=$xlsname.xls"); 
// header("Pragma: no-cache"); 
// header("Expires: 0"); 
// //run query
// $result = $mysqli->query($xlsquery);
// $numrows = mysqli_num_rows ($result);
// $numfields=mysqli_num_fields($result);
// $finfo = mysqli_fetch_fields($result);
// foreach ($finfo as $val) {
//     printf("%s\t", $val->name);
// }    
// echo "\n";
// while($row = mysqli_fetch_array($result))
//     {
//     for ( $i=0; $i < $numfields; $i++ )
//         { 
//         echo $row["$i"] . "\t";
//         }
//     echo "\n";
//     }
// echo "\n\n$numrows rows generated for $user at " . date("D j M Y  G:i:s");
// echo "\nYour query was: " . $xlsquery;
