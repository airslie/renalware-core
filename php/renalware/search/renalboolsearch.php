<?php
//Tue May  5 12:11:38 CEST 2009
require '../config_incl.php';
require '../incl/check.php';
//config
$thissearch="renalboolsearch"; //filename and folder ref
//paths
$searchurl="http://renalweb.kingsch.nhs.uk/renalware/search";
$searchpath="/Library/WebServer/Documents/renalware/search";
$connpath="/var/conns";
//reqs
require_once "$searchpath/req/fxns.php";
//devel
$debug = ($get_debug=="y") ? TRUE : FALSE ; // to cancel runsql
// Get starting time.
$start = microtime_float();
//SET DEFAULT AND NAVBAR LIST
$thisscreen = ($post_runsearch=='Y') ? "results" : "searchform";
//pagetitle
$pagetitle="Search Renalware (Boolean OR)";
if ($post_runsearch=='Y') {
    $pagetitle="Renalware--Boolean OR Search Results";
}
include '../parts/head_datatbl.php';
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
//get search config file
require "$searchpath/$thissearch/search_config.php";
if ($thisscreen=="searchform") {
   include "$searchpath/$thissearch/searchform_incl.html";
} else {
    //render results data
    include "$searchpath/$thissearch/searchprep_incl.php";
    //now display header & table itself (may want options here in future)
    require "$searchpath/incl/resultsheader_incl.php";
    require "$searchpath/incl/searchresults_incl.php";
}
//footer
include "$searchpath/incl/footer_incl.html";
?>