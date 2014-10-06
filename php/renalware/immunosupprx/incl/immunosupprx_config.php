<?php
//----Tue 15 Jul 2014----formusers DEPR; add send2epr config
//----Thu 20 Feb 2014----upload repeatrxdata form trial
//--Fri Nov 22 15:04:40 EST 2013--
$launchdate="Tue 15 July 2014"; //for occasional display; needs update on launch
$launchymd="2014-07-15";
$modulebase="immunosupprx";
$brandlabel="Renalware";
$modulelabel="Immunosupp Rx";
$pagetitles = array(
  'index' => 'Main Menu',
//  'list_rxpats' => 'Current Immunosupp Pats',
  'list_newrxpats' => 'New Immunosupp Rx Pats',
//  'list_currentrx' => 'Current Rx',
  'list_recentrx' => 'Recent Rx Changes',
//  'manage_repeatrx' => 'Manage Repeat Rx',
  'upload_repeatrxdata' => 'Upload Repeat Rx Data',
  'list_unprintedrepeatrx' => 'List Unprinted Repeat Rx',
  'list_repeatrxdata' => 'List Repeat Rx Data',
 // 'list_unprintedrx' => 'List Unprinted New Rx Drugs',
 // 'list_printedrx' => 'List Printed Rx Drugs',
  'list_printedrx' => 'List Printed Rx Forms',
);

$pagedescrs = array(
  'index' => 'Main Menu (this page)',
//  'list_rxpats' => 'List of patients currently receiving immunosuppressants',
  'list_newrxpats' => 'List of patients with recent immunosuppressant Rx (needing printing)',
//  'list_currentrx' => 'List of current immunosuppressant prescriptions',
  'list_recentrx' => 'List of immunosuppressant prescriptions that have changed in last 30 days',
  //'manage_repeatrx' => 'Import spreadsheet of Evolution repeat prescriptions for current month &amp; print forms',
  'upload_repeatrxdata' => 'Upload Repeat Rx Data from Evolution spreadsheet',
  'list_unprintedrepeatrx' => 'List and print the latest repeat prescriptions imported from Evolution',
  'list_repeatrxdata' => 'Archival List of repeat prescriptions imported from Evolution',
//  'list_unprintedrx' => 'Display recently-prescribed immunosuppressant drugs needing printing',
//  'list_printedrx' => 'Display RW-generated Printed Rx Drugs (mainly development use)',
  'list_printedrx' => 'List and view printed Rx forms',
);

$map_immunosupprepeatrxdata = array(
    'import_id'=>'import ID',
    'importstamp'=>'imported',
    'importdate'=>'import date',
    'evolution_id'=>'evolution ID',
    'firstname'=>'first name',
    'surname'=>'surname',
    'birthdate'=>'birthdate',
    'prescriber'=>'prescriber',
    'nextdelivdate'=>'next delivery ate',
    'hospital'=>'hospital',
    'hospno'=>'hospno',
    'nhsno'=>'NHS No',
    'patientdx'=>'patient Dx',
    'runflag'=>'run flag',
    'runuid'=>'run UID',
    'runuser'=>'run user',
    'rundt'=>'run DT',
);
//to send Rx Form to EPR (leave FALSE while testing)
$sendrxform2eprflag=false;
//users whose name will appear on form (handles problem where IM's secretary prints form)
$prescribers=array(
    'btucker',
    'sshaw',
    'imacdougall',
    'pnaugustx',
    'wshaw',
    'hcairns'
);
