<?php
//--Tue Sep 30 16:18:42 EDT 2014--
//start page config
$thispage="index";
$debug=false;
$pagetitle= "Shared Care Module--Main Menu";
//use datatables prn
$datatablesflag=false;
//include fxns and config
require 'req_fxnsconfig.php';
require "../bs3/incl/head_bs3.php";
require 'incl/sharedcare_nav.php';
echo '<div class="container">';
echo "<h1>$pagetitle</h1>";
bs_Alert("info","Note: Return to the main Renalware menubar by clicking on your username at top right. Click on the upper left purple tab to return to this Main Menu.");
echo '<table class="table table-bordered">
    <thead><tr><th>Menu Item</th><th>Description/Function</th></tr></thead>
    <tbody>';
foreach ($pagetitles as $key => $value) {
    $descr=$pagedescrs["$key"];
    echo '<tr><td><a href="'.$modulebase.'/'.$key.'.php">'.$value.'</a></td><td>'.$descr.'</td></tr>';
}
echo '</tbody>
    </table>';

    echo '<hr>
<h3>Shared Care Questions--reference</h3>
<table class="table table-condensed">';
 $topicno=0;
    foreach ($questions as $qno => $question) {
        $topicno ++;
        echo '<tr><th>'.$topicno.'</th><td>'.$question.'</td></tr>';
    }
echo '</table>';
//end page content
echo '</div>'; //container
require '../bs3/incl/footer_bs3.php';
