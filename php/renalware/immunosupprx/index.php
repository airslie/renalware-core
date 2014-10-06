<?php
//--Fri Nov 22 15:02:19 EST 2013--
//start page config
$thispage="index";
$debug=false;
$pagetitle= "Immunosupp Rx--Main Menu";
//use datatables prn
$datatablesflag=false;
//include fxns and config
require 'req_fxnsconfig.php';
require "../bs3/incl/head_bs3.php";
require 'incl/immunosupprx_nav.php';
echo '<div class="container">';
echo "<h1>$pagetitle</h1>";
bs_Alert("info","Note: Return to your Renalware home screen by clicking on the upper left purple tab.");
echo '<table class="table table-bordered">
    <thead><tr><th>Menu Item</th><th>Description/Function</th></tr></thead>
    <tbody>';
foreach ($pagetitles as $key => $value) {
    $descr=$pagedescrs["$key"];
    echo '<tr><td><a href="'.$modulebase.'/'.$key.'.php">'.$value.'</a></td><td>'.$descr.'</td></tr>';
}
echo '</tbody>
    </table>';
//end page content
echo '</div>'; //container
require '../bs3/incl/footer_bs3.php';
