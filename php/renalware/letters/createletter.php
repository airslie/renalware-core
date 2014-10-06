<?php
//----Fri 25 Oct 2013----add PRUH option
//----Mon 10 Jun 2013----NOTE re email alert now incl CDA
include '../req/confcheckfxns.php';
$zid = (int)$_GET['zid'];
//get pat data
include "$rwarepath/data/probs_meds.php";
include "$rwarepath/letters/data/letterpatdata.php";
include "$rwarepath/letters/data/letterpatholdata.php";
include "$rwarepath/data/currentclindata.php";
$pagetitle= "Create New Letter for $patfirstlast ($hospnos)";
//get header
include '../parts/head.php';
?>
<p class="buttonsdiv"><button style="color: red;" onclick="history.go(-1)">Cancel</button></p>
<form action="letters/run/runcreateletter.php" method="post">
	<input type="hidden" name="zid" value="<?php echo $zid; ?>" />
	<input name="letterdate" type="hidden" value="<?php echo date('d/m/Y'); ?>" />
	<fieldset class="letter">
	<legend><?php echo $pagetitle; ?></legend>

	<p><label>Letter Type</label><input type="radio" name="lettertype" value="clinic" checked="checked" onclick="$('#clinicalinfodiv').show()" />Clinic Letter for <b>Clinic Date:</b> 
		<?php
		$showclinicdate = ($_SESSION['clinicdate_dmy']) ? $_SESSION['clinicdate_dmy'] : Date("d/m/Y") ;
		?>
	 <input type="text" size="14" name="clinicdate" value="<?php echo $showclinicdate ?>" class="datepicker"/>&nbsp;&nbsp;<input type="radio" name="lettertype" value="simple" onclick="$('#clinicalinfodiv').hide()"/>Simple Letter (no probs/meds)</p>
<p><label>Letter Site</label>
<?php
//----Fri 25 Oct 2013----nb $lettersites array in config_incl.php
$checkedsite = ($sess_lettersite) ? $sess_lettersite : 'KCH' ; //default KRU
foreach ($lettersites as $key => $label) {
   if ($key==$checkedsite) {
       echo '<input type="radio" name="lettersite" value="'.$key.'" checked="checked">'.$label.' &nbsp; &nbsp;';
   } else {
       echo '<input type="radio" name="lettersite" value="'.$key.'">'.$label.' &nbsp; &nbsp;';
   }
}
?>
</p>
	<p><label>Description</label> <select name="lettertype_id">
	<?php
	if ($sess_letterdetails) {
		echo '<option value="' . $_SESSION['lettertype_id'] . '">' . $_SESSION['lettdescr'] . '</option>';
	}
	//get prior patient lettertypes
	$sql = "SELECT DISTINCT lettertype_id, lettdescr FROM letterdata WHERE letterzid=$zid AND lettertype_id>0 ORDER BY lettdescr";
	$result = $mysqli->query($sql);
	$numrows=$result->num_rows;
	if ($numrows) {
		echo '<optgroup label="Previous patient letter types">';
		while($row = $result->fetch_assoc())
			{
				echo '<option value="'.$row["lettertype_id"].'">'.$row["lettdescr"].'</option>';
			}
		echo '</optgroup>';
	}
	$result->close();
		//get clinic lettertypes
	echo '<optgroup label="'.$siteshort.' Clinic Letters">';
	$popcode="lettertype_id";
	$popname="letterdescr";
	$poptable="letterdescrlist";
	$popwhere="clinicflag=1";
	$poporder="ORDER BY letterdescr";
	include('../incl/limitedorderedoptions.php');
	echo '</optgroup>';
	//get other lettertypes
	echo '<optgroup label="other letter types">';
	$popcode="lettertype_id";
	$popname="letterdescr";
	$poptable="letterdescrlist";
	$popwhere="clinicflag=0";
	$poporder="ORDER BY letterdescr";
	include('../incl/limitedorderedoptions.php');
	echo '</optgroup>';
	?>
	</select></p>
	<p><label>Other Description</label> Use &ldquo;General Renal Letter&rdquo; or <a href="admin/letterdescrlist.php">add new Letter Description</a> (and return here afterwards)</p>
	<p><label>Author*</label> <select name="authorid">
	<?php
	if ($sess_letterdetails)
		{
		echo '<option value="' . $_SESSION['authorid'] . '">' . $_SESSION['authorlastfirst'] . '</option>';
		}
	else
		{
		echo "<option value=\"$uid\">$user [default]</option>";
		}
	//fill author list
		$sql= "SELECT uid, userlast, userfirst FROM userdata WHERE authorflag=1 ORDER BY userlast, userfirst";
		$result = $mysqli->query($sql);
		while ($row = $result->fetch_row()) {
		echo '<option value="' . $row['0'] . '">' . $row['1'] . ', ' . $row['2'] . "</option>";
		}
	?>
	</select></p>
	<p><label>Typist</label><input type="hidden" name="typistid" value="<?php echo $uid; ?>" />
	 <?php echo $user; ?> [default]</p>
	<p><label for="savedetails">Save details?</label><input type="checkbox" name="savedetails" id="savedetails" value="y" checked="checked" />Y ("Remembers" clinic date, description, author data for next letter(s)</p>
	<p><label>Recipient</label> &nbsp; &nbsp;<button onclick="window.open('pat/form.php?f=update_patient&amp;zid=<?php echo $zid; ?>','Edit Admin','width=900,height=600,scrollbars=yes')">Edit Admin Info (new window)</button></p>
	<table class="ui-corner-all" >
		<tr><td><input type="radio" name="recipienttype" value="gp" checked="checked" />GP 
			<?php
            //----Mon 10 Jun 2013----enhanced to display CDA prn
            $emailtext = ($sendemailflag) ? "email" : '' ;
            $cdatext = ($sendCDAflag) ? "Docman/CDA" : '' ;
			if ($sendemailflag or $sendCDAflag) {
				echo '<span class="hilite">Sent via: '. $emailtext . ' ' . $cdatext. '</span>';
			}
			?><br><textarea name="gpreciptext" rows="7" cols="60" ><?php echo $gpblock;
			//----Mon 30 Jan 2012----NB VIA email now in letterpatdata.php
		?></textarea></td><td><input type="radio" name="recipienttype" value="patient" />Patient <br><textarea name="patreciptext" rows="6" cols="30" ><?php echo $patblock; ?></textarea></td><td><input type="radio" name="recipienttype" value="otherrecip" />Other <br>
	<textarea name="otherreciptext" rows="6" cols="30" ></textarea></td></tr>
	</table>
	<div id="clinicalinfodiv">
	<?php include 'incl/showprobsmeds_incl.php'; ?>
	<input  type="submit" name="create" value="Continue to next screen (to edit probs/meds now)" /><br>
<p><label>Recent Investigations (IMPORTANT: KCH pathology results only appear in KCH letters (not DVH/PRUH/QEH))</label><br><?php echo $current_lettresults; ?></p>
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
<p><label>BP</label> <input type="text" name="lettBPsyst" size="3" />/<input type="text" name="lettBPdiast" size="3" /> &nbsp; &nbsp; <label>Weight</label> <input type="text" name="lettWeight" size="5" />kg &nbsp; &nbsp; <label>Height</label> <input type="text" name="lettHeight" size="4" value="<?php echo $Height; ?>" />meters
&nbsp;&nbsp; <label>Urine Protein</label> <select name="letturine_prot" id="letturine_prot"><?php echo $urineprot_options ?></select>
&nbsp;&nbsp; <label>Urine Blood</label> <select name="letturine_blood" id="letturine_blood"><?php echo $urineblood_options ?></select>
</p>
	<p><label>Allergies</label> <?php echo $allergies; ?></p>
	<p><label>Insert Template/Snippet?</label> <select name="templateid" onchange="appendTemplate(this.value)">
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
	</div>
	<textarea name="ltext" id="ltext" style="background: #fff;" rows="20" cols="100" ></textarea>
	</fieldset>
<input type="submit" name="create" value="Review Draft and add CCs..." />
</form>
</body>
</html>
<script>
function appendTemplate(tid) {
	$.post("letters/ajax/get_templatetext.php", { id: tid },
	   function(data){
	     $('#ltext').append(data);
	   });			
	}
</script>