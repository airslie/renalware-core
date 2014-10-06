<?php
//----Fri 15 Nov 2013----KCH results only warning and streamlining
//Fri Aug  8 16:54:43 CEST 2008 merged for clinic and simple
$legend= "Edit Letter ID $letter_id Info--$lettdescr [Letter Site: $lettersite]";
?>
<form action="letters/runedit.php" method="post" id="editletterform">
<fieldset>
<legend><?php echo $legend ?></legend>
<input type="hidden" name="letterzid" value="<?php echo $zid; ?>" />
<input type="hidden" name="letter_id" value="<?php echo $letter_id; ?>" />
<input type="hidden" name="lettertype" value="<?php echo $lettertype ?>" />
<p><label>Patient Ref</label> <?php echo $patref ?></p>
<p><label>Patient Addr</label> <?php echo $pataddrhoriz ?></p>
<p><label>Letter Date</label> <?php echo $letterdate; ?></p>
<?php if ($lettertype=="clinic"): ?>
	<p><label>Clinic Date</label><br>
		<input type="text" name="clinicdatedmy" size="14" value="<?php echo $clinicdate; ?>" class="datepicker" /></p>
<?php endif ?>
<p><label>Description</label> <select name="lettertype_id">
<?php
echo "<option value=\"$lettertype_id\">$lettdescr</option>";
$popcode="lettertype_id";
$popname="letterdescr";
$poptable="letterdescrlist";
$poporder="ORDER BY letterdescr";
include('../incl/simpleoptions.php');
?>
</select></p>
<p><label>Author</label> <select name="authorid">
<?php
	echo '<option value="' . $authorid . '">' . $authorlastfirst . '</option>';
//fill author list
	$sql = "SELECT uid, userlast, userfirst FROM renalware.userdata WHERE authorflag=1 ORDER BY userlast, userfirst";
	$result = $mysqli->query($sql);
	while($row = $result->fetch_assoc())
	{
	echo '<option value="' . $row['uid'] . '">' . $row['userlast'] . ', ' . $row['userfirst'] . "</option>";
	}
?>
</select></p>
<?php
//fix salut
$namewords = explode(" ", $recipname);
$no_namewords = count($namewords) - 1;
$title_lastname = $namewords[0] . ' ' . $namewords[$no_namewords]; //??!!
if (!$salut)
	{
	$salutvalue = "Dear " . $recipname;
	}
else
	{
	$salutvalue = $salut;
	}
?>
<p><label>Recipient</label> <i>Edit if necessary</i></p>
<textarea name="recipient" rows="7" cols="60">
<?php echo $recipient; ?>
</textarea>
<p><label for="salut">Salutation</label><br>
	<input type="text" name="salut" id="salut" size="50" value="<?php echo $salutvalue; ?>" /></p>
<?php if ($lettertype=="clinic"): ?>
<?php
include "$rwarepath/letters/incl/probsmedspath_links.php";
include 'incl/showprobsmeds_incl.php';
?>
    		<p><label>Recent Investigations (IMPORTANT: Results displayed below only appear in KCH letters)</label> <i>Add/edit as needed</i></p>
    		<textarea name="lettresults" rows="6" cols="100"><?php echo $lettresults; ?></textarea>
    		<br>
<?php
//try to get Ht ----Sun 22 Jul 2012----
$currHt = ($lettHeight) ? $lettHeight : $Height ;
//fix for "0" BPs Wts
$showBPsyst = ($lettBPsyst) ? $lettBPsyst : "" ;
$showBPdiast = ($lettBPdiast) ? $lettBPdiast : "" ;
$showWeight = ($lettWeight) ? $lettWeight : "" ;
$showHeight = ($currHt) ? $currHt : "" ;
$urineprotoption = ($letturine_prot) ? "<option>$letturine_prot" : '<option value="">Select...</option>' ;
$urinebloodoption = ($letturine_blood) ? "<option>$letturine_blood" : '<option value="">Select...</option>' ;
//----Sun 22 Jul 2012----for blood prot/urine
$urineleveloptions='<option>neg</option>
 <option>trace</option>
 <option>+</option>
 <option>++</option>
 <option>+++</option>
 <option>++++</option>';
 $urineprot_options=$urineprotoption.$urineleveloptions;
 $urineblood_options=$urinebloodoption.$urineleveloptions;
?>
		<p><label>BP</label> <input type="text" name="lettBPsyst" size="3" value="<?php echo $showBPsyst; ?>">/<input type="text" name="lettBPdiast" size="3" value="<?php echo $showBPdiast; ?>"> &nbsp;&nbsp; <label>Weight</label> <input type="text" name="lettWeight" size="5" value="<?php echo $showWeight; ?>">kg &nbsp;&nbsp; <label>Height</label> <input type="text" name="lettHeight" size="4" value="<?php echo $showHeight; ?>" />meters
&nbsp;&nbsp; <label>Urine Protein</label> <select name="letturine_prot" id="letturine_prot"><?php echo $urineprot_options ?></select>
&nbsp;&nbsp; <label>Urine Blood</label> <select name="letturine_blood" id="letturine_blood"><?php echo $urineblood_options ?></select>
</p>
		<p><label>Allergies</label> <?php echo $lettallergies; ?></p>
<?php endif ?>
<?php
makeInfo("TIP","<b>*pagebreak*</b> (all lower case) to insert a page break in the letter text field.<br>
	(You may use more than one or delete if indicated)");
?>
		<p><label>Append Template/Snippet?</label> <select name="templateid" onchange="appendTemplate(this.value)">
		<option value="">Select from <?php echo $user; ?>&rsquo;s templates...</option>
<?php
$popcode="template_id";
$popname="templatename";
$popwhere="templateuid=$uid";
$poptable="lettertemplates";
$poporder="ORDER BY templatename";
include('../incl/limitedorderedoptions.php');
?>
		</select></p>
<p><label for="ltext">Letter text</label></p>
<textarea name="ltext" id="ltext" style="background: #fff;" rows="30" cols="100"><?php echo $ltext; ?></textarea>
<br>
<p><label>Create New Snippet or Template?</label><input type="checkbox" name="newtemplateflag" value="1" onclick="$('#addtemplatediv').toggle()" />Yes</p>
<div id="addtemplatediv" style="display:none">
	<p style="color: red">Copy/paste new snippet or template text from above and give it a descriptive name (e.g. "Access Clinic DNA Template").<br>It will be added to your collection when you Submit this letter.</p>
	<p><label>Snippet/Template Name *REQUIRED*</label><br>
	<input type="text" name="newtemplatename" size="70" id="newtemplatename" /></p>
	<p><label>Snippet/Template Text</label></p>
	<textarea name="newtemplatetext" id="newtemplatetext" rows="10" cols="100"></textarea>
</div>
Yours sincerely,
<br><br>
<?php echo "<b>$authorsig</b> <br>$position"; ?>
<br>
<?php
include "$rwarepath/letters/incl/ccsfieldset_incl.php";
include "$rwarepath/letters/incl/statusfieldset_incl.php";
?>
<input type="submit" class="ui-state-default" style="color: green;" value="CONTINUE" />
</fieldset>
</form>
<script>
function appendTemplate(tid) {
	$.post("letters/ajax/get_templatetext.php", { id: tid },
	   function(data){
	     $('#ltext').append(data);
	   });			
	}
</script>