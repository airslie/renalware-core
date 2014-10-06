<?php
//----Wed 23 Jun 2010----
include "$rwarepath/data/hddata.php";
?>
<div class="ui-state-default datadiv">
<b>Site:</b> <?php echo $currsite; ?> <b>Pref</b>: <?php echo $prefsite; ?>&nbsp;&nbsp;<b>schedule:</b> <b><?php echo $currsched . '-' . $currslot; ?></b> &nbsp;&nbsp;
<b>Named Nurse:</b> <?php echo $namednurse; ?></b>&nbsp;&nbsp;<b>Hours:</b> <?php echo $hours; ?></b>&nbsp; &nbsp;<b>Type:</b> <?php echo $hdtype; ?><br>
<b>Current access:</b> <?php echo $accessCurrent; ?> (<b>formed:</b> <?php echo $accessCurrDate; ?>)&nbsp;&nbsp;<b>Access Plan: </b> <?php echo $accessPlan . " ($accessPlanner -- $accessPlandate)" ?><br>
<b>BP Statistics: </b> <?php echo "BP max PRE: $maxsyst_pre/$maxdiast_pre&nbsp;&nbsp; max POST: $maxsyst_post/$maxdiast_post&nbsp;&nbsp;BP min PRE: $minsyst_pre/$mindiast_pre&nbsp;&nbsp; min POST: $minsyst_post/$mindiast_post&nbsp;&nbsp;<b>BP avg PRE: $avgsyst_pre/$avgdiast_pre&nbsp;&nbsp; avg POST: $avgsyst_post/$avgdiast_post</b>"; ?><br>
</div>