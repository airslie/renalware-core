<?php
//--Fri Mar  8 10:58:41 EST 2013--
//standard SQL plus any special handling here
//assumes primary id upstream
$sql= "SELECT * FROM txops WHERE txop_id=$txop_id LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
//specials below