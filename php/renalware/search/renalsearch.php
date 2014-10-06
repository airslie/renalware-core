<?php
//----Sun 08 Sep 2013----datatables, mainnav
//Tue May  5 12:11:38 CEST 2009
//debugging Sat Aug 22 16:27:17 CEST 2009
//----Wed 07 Jul 2010----jq upgrading
require '../config_incl.php';
include '../incl/check.php';
//config
$thissearch="renalsearch"; //filename and folder ref
//paths
$searchurl="$rwareroot/search";
$searchpath="$rwarepath/search";
$connpath="/var/conns";
//reqs
include_once "$searchpath/req/fxns.php";
//devel
$debug = ($get_debug=="y") ? TRUE : FALSE ; // to cancel runsql
// Get starting time.
$start = microtime_float();
//SET DEFAULT AND NAVBAR LIST
$thisscreen = ($post_runsearch=='Y') ? "results" : "searchform";
//pagetitle
$pagetitle="Search Renalware";
if ($post_runsearch=='Y') {
    $pagetitle="Renalware--Search Results";
}
include '../parts/head_datatbl.php';
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
//get search config file
include "$searchpath/$thissearch/search_config.php";
if ($thisscreen=="searchform") {
   include "$searchpath/$thissearch/searchform_incl.html";
} else {
    //render results data
    include "$searchpath/$thissearch/searchprep_incl.php";
    //now display header & table itself (may want options here in future)
    include "$searchpath/incl/resultsheader_incl.php";
    include "$searchpath/incl/searchresults_incl.php";
}
//footer
include "$searchpath/incl/footer_incl.html";
