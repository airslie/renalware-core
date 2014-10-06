<?php
//Fri May  8 16:18:40 CEST 2009
?>
<form action="pat/patient.php?vw=modals&amp;zid=<?php echo $zid; ?>&amp;add=modal" method="post">
<fieldset>
<legend>Add new modality for <?php echo $firstnames . ' ' . $lastname; ?></legend>
<b>Important:</b> Enter the Site for all HD and PD patients. HD Ward and Home HD are "KRU".<br>
<ul class="form">
<li><label for="modalcode">New modality</label>&nbsp;<select id="modalcode" name="modalcode"><option value="">Select New Modality...</option>
<?php
$popcode="modalcode";
$popname="modality";
$poptable="modalcodeslist";
$poporder="ORDER BY modality";
include('../incl/simpleoptions.php');
?>
</select></li>
<li><label for="modalsitecode">Dialysis site (if HD)</label>&nbsp;<select id="modalsitecode" name="modalsitecode"><option value="">None (DEFAULT)</option>
<?php
$popcode="sitecode";
$popname="sitename";
$poptable="sitelist";
$poporder="ORDER BY sitename";
include('../incl/simpleoptions.php');
?>
</select></li>
<li><label for="modaldate">Date changed</label>&nbsp;<input id="modaldate" type="text" size="10" name="modaldate" value="<?php echo date("d/m/Y") ?>" class="datepicker"/></li>
<li><label for="modalnotes">Notes</label>&nbsp;<input type="text" id="modalnotes" name="modalnotes" size="40" /></li>
<li class="submit"><input type="submit" style="color: green;" value="add modality" /></li>
</ul>
</fieldset>
</form>