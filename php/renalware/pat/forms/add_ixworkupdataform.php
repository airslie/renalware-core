<div id="adddataform" style="display: none;">
	<form action="<?php echo $pagevw ?>&amp;run=add" method="post">
        <input type="hidden" name="ixworkupmodal" value="<?php echo $modalcode ?>" id="ixworkupmodal">
	<fieldset>
	<legend>Add new Investigation for <?php echo $firstnames . ' ' . $lastname; ?></legend>
	<ul class="form">
	<li><label for="ixworkupdate">Date</label>&nbsp;<input type="text" name="ixworkupdate" id="ixworkupdate" value="<?php echo date("d/m/Y") ?>"class="datepicker" size="12" /></li>
	<li><label for="ixworkuptype">Type</label>&nbsp;<select id="ixworkuptype" name="ixworkuptype">
        <?php echo $listhtml ?>
    </select></li>
	<li><label for="ixworkupresults">Results Summary (255 char max)</label>&nbsp;<textarea id="ixworkupresults" name="ixworkupresults" rows="2" cols="100"></textarea></li>
	<li><label for="ixworkuptext">Notes/Raw Data</label>&nbsp;<textarea id="ixworkuptext" name="ixworkuptext" rows="5" cols="100"></textarea></li>
    <li class="submit"><input type="submit" style="color: green;" value="add Investigation" />&nbsp;&nbsp;
	<input type="button" class="ui-state-default" style="color: white; background: red; border: red;" value="cancel" onclick="$('#adddataform').hide('slow')"/></li>
    </ul>
    </fieldset>
    </form>
</div>