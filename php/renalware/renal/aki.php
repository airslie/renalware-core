<?php
//--Mon Mar  4 13:46:04 EST 2013--
$thismode = ($get_mode) ? $get_mode : 'view_summ' ;
//maps
include 'aki/aki_config.php';
//handle POSTs
if ($_POST['runscript'])
	{
    require "aki/$post_runscript.php";
} // end update IF

//incl mode
include "aki/$thismode.php";
