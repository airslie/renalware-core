<?php
//Sun May 10 17:57:23 CEST 2009
?>
<ul class="portal">
<li><b>site:</b> <?php echo $currsite; ?> <i>Pref: <?php echo $prefsite; ?></i>&nbsp;&nbsp;</li>
<li><b>sched:</b> <b><?php echo $currsched . '-' . $currslot; ?></b> <i>Pref: <?php echo $prefsched . '-' . $prefslot; ?></i></li>
<li><b>curr access:</b> <?php echo $accessCurrent; ?> (<b>formed:</b> <?php echo $accessCurrDate; ?>)&nbsp;&nbsp;</li>
<li><b>access Plan:</b> <?php echo $accessPlan; ?> (<b>planned</b> <?php echo $accessPlandate . ' <b>by</b> ' . $accessPlanner; ?>)</li>
<li><b>Named Nurse:</b> <?php echo $namednurse; ?>&nbsp;&nbsp;<b>hours:</b> <?php echo $hours; ?></b>&nbsp; &nbsp;</li>
<li><b>Dry Wt:</b> <?php echo $dryweight; ?> <i>kg</i></b>&nbsp;&nbsp;</li>
<li><b>Avg BPs: </b> <?php echo "<b>Pre:</b> $avgsyst_pre/$avgdiast_pre &nbsp; <b>Post:</b> $avgsyst_post/$avgdiast_post";?></li>
</ul>
<table border="0">
<td valign="top" width="400">
<?php
include('../portals/currmedsportal.php');
echo '</td><td valign="top">';
include('incl/esahxtable.php');
 echo '</td></tr></table>';
$limit=10;
include "$rwarepath/pathology/patresults_summ.php";
$portallimit=5;
include( '../portals/lettersportal.php' );
