<?php
//----Fri 06 Sep 2014----revert beta URL back to /rwbeta w/o version no for simplicity
//----Fri 22 Nov 2013----hostname and $path_to_downloads
//----Fri 15 Nov 2013----now unified config_local based on upstream $configstatus in config_status.php
switch ($configstatus) {
    case 'DEVEL':
    $hostname="localhost";
    ini_set("error_reporting", "E_COMPILE_ERROR|E_RECOVERABLE_ERROR|E_ERROR|E_CORE_ERROR");
    ini_set("display_errors", 0);

    $port = $_ENV["PHP_ENV"] == 'test' ? "8001" : "8000";

    // $rwarepath="/Library/WebServer/Documents/renalware";
    $rwarepath=realpath($_SERVER['DOCUMENT_ROOT']);
    // $rwareroot="http://$hostname/renalware";
    $rwareroot="http://$hostname:$port";
    // ----------SET LOCAL PATHS HERE ------------
    //DB connection here
    $db="renalware";
    require_once realpath($_SERVER['DOCUMENT_ROOT']).'/renalwareconn.php';

    // ***** set prn
    //path to letter-HTML versions
    $HTMLarchivepath="/Users/Shared/eprfolders/htmlarchive";
    //change the following for the desired KCH directory ***must have write privileges***
    //do not end with "/"!
    //relevant code in runedit.php is:
    //$handle = fopen("$EPRpath/Renal\ $EPRtype\ Letter/$htmlfilename", "w");
    $EPRpath="/Users/Shared/eprfolders/EPR_temp";
    //----Mon 30 Jan 2012----for GP email letters
    $gp_emails_path="/Users/Shared/eprfolders/renal_gp_letters";
    $gp_emails_path_pdf="/Users/Shared/eprfolders/renal_gp_letters_pdf";
    //path to downloads folder; should be at web root level as 'krudownloads/']
    $path_to_krudownloads="http://$hostname/krudownloads";
    //set DB
    $db="renalware";
    break;

    case 'BETA':
   //KCH settings removed
     break;

     case 'LIVE':
  //KCH settings removed
       break;
}
$mysqli->select_db("$db");
