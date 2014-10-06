<table>
<tr><td class="fldview">patient</td><td class="data"><?php echo $patient; ?></td></tr>
<tr><td class="fldview">hosp no</td><td class="data"><?php echo $hospno; ?></td></tr>
<tr><td class="fldview">sex/DOB</td><td class="data"><?php echo $sex; ?> (<?php echo $age ?>) <?php echo $birthdate; ?></td></tr>
<tr><td class="fldview">modality</td><td class="data"><?php echo $modalcode . '--' . $modalsite; ?></td></tr>
<tr><td class="fldview">HD sched/slot</td><td class="data"><?php echo $currsched . '--' . $currslot; ?></td></tr>
<tr><td class="fldview">address</td><td class="data"><?php echo $addr1; ?><br>
<?php echo $addr2; ?><br>
<?php echo $addr3; ?><br>
<?php echo $addr4; ?> <?php echo $postcode; ?></td></tr>
<tr><td class="fldview">tel1</td><td class="data"><?php echo $tel1; ?></td></tr>
<tr><td class="fldview">tel2</td><td class="data"><?php echo $tel2; ?></td></tr>
<tr><td class="fldview">mobile</td><td class="data"><?php echo $mobile; ?></td></tr>
<tr><td class="fldview">HD transport?</td><td class="data"><?php echo $transporttype; ?></td></tr>
</table>
