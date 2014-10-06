<?php
//  Created by Paul Nordstrom August on 2007-11-12.
//  Copyright (C) 2007-2008 Paul Nordstrom August
//
require '../../config_incl.php';
include '../../incl/check.php';
include '../../fxns/fxns.php';
include '../../fxns/formfxns.php';
//separate header w/ form css
include "$rwarepath/parts/head.php";
extract($_GET,EXTR_PREFIX_ALL,'get');
$zid = $get_zid;
if ($zid) {
	include "$rwarepath/data/patientdata.php";
	include "$rwarepath/data/psychsocialdata.php";
}
#*******************************************SET UP*******************************************
//set table
$table="renaldata";
//set table name
$tablename="Psych/Social";
//table metadata
$formzid="renalzid";
$mode="add";
// set OPTIONLISTS prn;
#*******************************************END SET UP*******************************************
?>
<h4><?php echo $patref_addr ?></h4>
<input type="button" class="ui-state-default" style="color: white; background: red; border: red;"  value="Cancel--Return to previous page" onclick="javascript:history.go(-1)"/>
<form action="pat/run/psychsocial_update.php" method="post" accept-charset="utf-8">	
	<input type="hidden" name="zid" value="<?php echo $get_zid ?>" id="zid">
<fieldset>
<legend>Add/Update <?php echo $tablename . ' Data'; ?></legend>
<ul class="form">
<?php
inputTextarea("psychsoc_housing","Housing",10,100,$psychsoc_housing);
inputTextarea("psychsoc_socialnetwork","Social Network",10,100,$psychsoc_socialnetwork);
inputTextarea("psychsoc_carepackage","Care Package",10,100,$psychsoc_carepackage);
inputTextarea("psychsoc_other","Other",10,100,$psychsoc_other);
?>
<li class="submit"><input type="submit" style="color: green;" value="Add/Update Data" /></li>
</ul>
</fieldset>
</form>
</div>
</body>
</html>