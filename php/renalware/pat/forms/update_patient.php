<form action="pat/run/run_updatepatdata.php" method="post">
<fieldset>
<legend><?php echo $legend ?></legend>
<input type="hidden" name="patzid" value="<?php echo $zid; ?>" id="patzid" />
<?php if ($get_letter_id): ?>
	<input type="hidden" name="letter_id" value="<?php echo $letter_id; ?>" id="get_letter_id" />
<?php endif ?>
<ul class="form">
<li class="hdr">PATIENT DATA</li>
<li><label><?php echo $hosp1label; ?></label>&nbsp;&nbsp;<input type="text" name="hospno1" value="<?php echo $hospno1; ?>" size="20" /></li>
<li><label><?php echo $hosp2label; ?></label>&nbsp;&nbsp;<input type="text" name="hospno2" value="<?php echo $hospno2; ?>" size="20" /></li>
<li><label><?php echo $hosp3label; ?></label>&nbsp;&nbsp;<input type="text" name="hospno3" value="<?php echo $hospno3; ?>" size="20" /></li>
<li><label><?php echo $hosp4label; ?></label>&nbsp;&nbsp;<input type="text" name="hospno4" value="<?php echo $hospno4; ?>" size="20" /></li>
<li><label><?php echo $hosp5label; ?></label>&nbsp;&nbsp;<input type="text" name="hospno5" value="<?php echo $hospno5; ?>" size="20" /></li>
<li><label>NHS No</label>&nbsp;&nbsp;<input type="text" name="nhsno" value="<?php echo $nhsno; ?>" size="14" /></li>
<li><label>title</label>&nbsp;&nbsp;
	<select name="title">
	<option><?php echo $title; ?></option>
	<option>Mr</option>
	<option>Ms</option>
	<option>Mrs</option>
	<option>Miss</option>
	<option>Dr</option>
	<option>Prof</option></select>
	</li>
<li><label>Surname</label>&nbsp;&nbsp;<input type="text" name="lastname" value="<?php echo $lastname; ?>" size="30" /></li>
<li><label>Forename(s)</label>&nbsp;&nbsp;<input type="text" name="firstnames" value="<?php echo $firstnames; ?>" size="30" /></li>
<li><label>Sex</label>&nbsp;&nbsp;
	<select name="sex">
	<option><?php echo $sex; ?></option>
	<option value="M">Male</option>
	<option value="F">Female</option>
	</select>
	</li>
<li><label>DOB (dd/mm/YYYY)</label>&nbsp;&nbsp;<input type="text" name="birthdate" value="<?php echo $birthdate; ?>" class="datepicker" size="12" /></li>
<li><label>Date of Death</label>&nbsp;&nbsp;<input type="text" name="deathdate" value="<?php echo $deathdate; ?>" class="datepicker" size="12" /></li>
<li><label>Marital Status</label>&nbsp;&nbsp;
	<select name="maritstatus">
	<option><?php echo $maritstatus; ?></option>
	<option>Unknown</option>
	<option>Married</option>
	<option>Single</option>
	<option>Divorced</option>
	<option>Widowed</option>
	</select>
	</li>
<li><label>Ethnicity</label>&nbsp;&nbsp;
	<select name="ethnicity">
	<option><?php echo $ethnicity; ?></option>
	<?php include( '../optionlists/ethnicities.html' ); ?>
	</select>
	</li>
<li><label>Religion</label>&nbsp;&nbsp;
	<select name="religion">
	<option><?php echo $religion; ?></option>
	<?php include( '../optionlists/religions.html' ); ?>
	</select>
	</li>
<li><label>Language</label>&nbsp;&nbsp;
	<select name="language">
	<option><?php echo $language; ?></option>
	<?php include( '../optionlists/languages.html' ); ?>
	</select>
	</li>
<li><label>CC letters?</label>&nbsp;&nbsp;
	<input type="radio" name="ccflag" value="Y" <?php if ( $ccflag=='Y' ) { echo 'checked="checked"'; } ?>>Yes 
	<input type="radio" name="ccflag" value="N" <?php if ( $ccflag=='N' ) { echo 'checked="checked"'; } ?>>No &nbsp;&nbsp;<label>Date asked:</label>&nbsp;&nbsp;<input type="text" name="ccflagdate" value="<?php echo $ccflagdate; ?>" class="datepicker" size="12" /></li>
	<li><label>Admin Notes</label><br><textarea name="adminnotes" rows="5" cols="60"><?php echo $adminnotes ?></textarea></li>
	<li><label>Default CCs</label><br><textarea name="defaultccs" rows="10" cols="60"><?php echo $defaultccs ?></textarea></li>
	<li class="hdr">PATIENT CONTACT INFO</li>
<li><label>Addr1</label>&nbsp;&nbsp;<input type="text" name="addr1" value="<?php echo $addr1; ?>" size="50" /></li>
<li><label>Addr2</label>&nbsp;&nbsp;<input type="text" name="addr2" value="<?php echo $addr2; ?>" size="50" /></li>
<li><label>Addr3</label>&nbsp;&nbsp;<input type="text" name="addr3" value="<?php echo $addr3; ?>" size="50" /></li>
<li><label>Addr4</label>&nbsp;&nbsp;<input type="text" name="addr4" value="<?php echo $addr4; ?>" size="50" /></li>
<li><label>postcode</label>&nbsp;&nbsp;<input type="text" name="postcode" value="<?php echo $postcode; ?>" size="50" /></li>
<li><label>tel1</label>&nbsp;&nbsp;<input type="text" name="tel1" value="<?php echo $tel1; ?>" size="50" /></li>
<li><label>tel2</label>&nbsp;&nbsp;<input type="text" name="tel2" value="<?php echo $tel2; ?>" size="50" /></li>
<li><label>fax</label>&nbsp;&nbsp;<input type="text" name="fax" value="<?php echo $fax; ?>" size="50" /></li>
<li><label>mobile</label>&nbsp;&nbsp;<input type="text" name="mobile" value="<?php echo $mobile; ?>" size="50" /></li>
<li><label>email</label>&nbsp;&nbsp;<input type="text" name="email" value="<?php echo $email; ?>" size="50" /></li>
<li><label>temp address</label>&nbsp;&nbsp;<input type="text" name="tempaddr" value="<?php echo $tempaddr; ?>" size="50" /></li>
<li class="hdr">TRANSPORT INFO</li>
<li><label>Needs:</label>&nbsp;&nbsp;<input type="radio" name="transportflag" <?php if($transportflag=="Y") { echo 'checked="checked"'; } ?> value="Y" />Y
&nbsp; &nbsp; <input type="radio" name="transportflag" <?php if($transportflag=="N") {echo 'checked="checked"';} ?> value="N" />N</li>
<li><label>Type:</label>&nbsp;&nbsp;<select name="transporttype">
	<?php
$optionfield="transporttype";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
	include( '../optionlists/transporttypes.html' );
	?>
	</select></li>
<li><label>Decider</label>&nbsp;&nbsp;	<select name="transportdecider">
	<?php
	$optionfield="transportdecider";
	if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
			$popcode="userlast";
			$popname="userlast";
			$popwhere="transportdeciderflag=1";
			$poptable="userdata";
			include('../incl/limitedoptions.php');
	?>
	</select></li>
<li><label>Updated</label>&nbsp;&nbsp;<input type="text" name="transportdate" value="<?php echo $transportdate; ?>" size="12" /></li>

<li class="hdr">RENAL REGISTRY ("Opt Out"=No identifiers sent)</li>
<li><label>&lsquo;Opt Out&rsquo;?</label>&nbsp;&nbsp;
	<input type="radio" name="renalregoptout" value="Y" <?php if ( $renalregoptout=='Y'  or !$renalregoptout) { echo 'checked="checked"'; } ?>>Yes (Default)&nbsp;&nbsp;
	<input type="radio" name="renalregoptout" value="N" <?php if ( $renalregoptout=='N' ) { echo 'checked="checked"'; } ?>>No (OK to send identifiers) </li>
	<li><label>Date recorded:</label>&nbsp;&nbsp;<input type="text" name="renalregdate" value="<?php echo $renalregdate; ?>" class="datepicker" size="12" /></li>
	<li><label>Recorded by:</label>&nbsp;&nbsp;<input type="text" name="renalregstaff" value="<?php echo $renalregstaff; ?>" size="30" /></li>
<li class="hdr">Change/Edit GP</li>
<li><label>GP natcode</label>&nbsp;&nbsp;<input type="text" name="gp_natcode" value="<?php echo $gp_natcode; ?>" size="16" /></li>
<li><label>GP name</label>&nbsp;&nbsp;<input type="text" name="gp_name" value="<?php echo $gp_name; ?>" size="50" /></li>
<li><label>GP addr1</label>&nbsp;&nbsp;<input type="text" name="gp_addr1" value="<?php echo $gp_addr1; ?>" size="50" /></li>
<li><label>GP addr2</label>&nbsp;&nbsp;<input type="text" name="gp_addr2" value="<?php echo $gp_addr2; ?>" size="50" /></li>
<li><label>GP addr3</label>&nbsp;&nbsp;<input type="text" name="gp_addr3" value="<?php echo $gp_addr3; ?>" size="50" /></li>
<li><label>GP addr4</label>&nbsp;&nbsp;<input type="text" name="gp_addr4" value="<?php echo $gp_addr4; ?>" size="50" /></li>
<li><label>GP postcode</label>&nbsp;&nbsp;<input type="text" name="gp_postcode" value="<?php echo $gp_postcode; ?>" size="12" /></li>
<li><label>GP tel</label>&nbsp;&nbsp;<input type="text" name="gp_tel" value="<?php echo $gp_tel; ?>" size="20" /></li>
<li><label>GP fax</label>&nbsp;&nbsp;<input type="text" name="gp_fax" value="<?php echo $gp_fax; ?>" size="20" /></li>
<li><label>GP email</label>&nbsp;&nbsp;<input type="text" name="gp_email" value="<?php echo $gp_email; ?>" size="30" /></li>
<li class="hdr">REFERRAL INFO</li>
<li><label>Referred by:</label>&nbsp;&nbsp;<input type="text" name="referrer" value="<?php echo $referrer; ?>" size="50" /></li>
<li><label>Referral date</label>&nbsp;&nbsp;<input type="text" name="refer_date" value="<?php echo $refer_date; ?>" size="12" /></li>
<li><label>Referral type</label>&nbsp;&nbsp;<input type="text" name="refer_type" value="<?php echo $refer_type; ?>" size="50" /></li>
<li><label>Referral notes</label>&nbsp;&nbsp;<input type="text" name="refer_notes" value="<?php echo $refer_notes; ?>" size="50" /></li>
<li class="hdr">PHARMACIST INFO</li>
<li><label>Pharmacist</label>&nbsp;&nbsp;<input type="text" name="pharmacist" value="<?php echo $pharmacist; ?>" size="50" /></li>
<li><label>Telephone(s)</label>&nbsp;&nbsp;<input type="text" name="pharmacist_phone" value="<?php echo $pharmacist_phone; ?>" size="50" /></li>
<li><label>Address</label> <b>(255 chars max)*</b><br><textarea name="pharmacist_addr" rows="5" cols="60"><?php echo $pharmacist_addr ?></textarea>
<li class="hdr">DISTRICT NURSE INFO</li>
<li><label>District Nurse</label>&nbsp;&nbsp;<input type="text" name="districtnurse" value="<?php echo $districtnurse; ?>" size="50" /></li>
<li><label>Telephone(s)</label>&nbsp;&nbsp;<input type="text" name="districtnurse_phone" value="<?php echo $districtnurse_phone; ?>" size="50" /></li>
<li><label>Address</label> <b>(255 chars max)*</b><br><textarea name="districtnurse_addr" rows="5" cols="60"><?php echo $districtnurse_addr ?></textarea>
</li>
<li class="hdr">NEXT OF KIN INFO</li>
<li><label>Next of Kin</label>&nbsp;&nbsp;<input type="text" name="nok_name" value="<?php echo $nok_name; ?>" size="50" /></li>
<li><label>NOK addr1</label>&nbsp;&nbsp;<input type="text" name="nok_addr1" value="<?php echo $nok_addr1; ?>" size="50" /></li>
<li><label>NOK addr2</label>&nbsp;&nbsp;<input type="text" name="nok_addr2" value="<?php echo $nok_addr2; ?>" size="50" /></li>
<li><label>NOK addr3</label>&nbsp;&nbsp;<input type="text" name="nok_addr3" value="<?php echo $nok_addr3; ?>" size="50" /></li>
<li><label>NOK addr4</label>&nbsp;&nbsp;<input type="text" name="nok_addr4" value="<?php echo $nok_addr4; ?>" size="50" /></li>
<li><label>NOK postcode</label>&nbsp;&nbsp;<input type="text" name="nok_postcode" value="<?php echo $nok_postcode; ?>" size="50" /></li>
<li><label>NOK tels</label>&nbsp;&nbsp;<input type="text" name="nok_tels" value="<?php echo $nok_tels; ?>" size="50" /></li>
<li><label>NOK email</label>&nbsp;&nbsp;<input type="text" name="nok_email" value="<?php echo $nok_email; ?>" size="50" /></li>
<li class="hdr">IMMUNOSUPPRESSANTS</li>
<li><label>Drug Delivery</label>&nbsp;&nbsp;<select name="immunosuppdrugdelivery">
	<option><?php echo $immunosuppdrugdelivery; ?></option>
	<option>GP</option>
	<option>Hosp</option>
	<option>HospHomeDelivery</option>
	</select>
</li>
<!--
<li class="hdr">"Permanent CC" field</li>
<li class="data"><b>Name and address to be included in all letter CCs (250 chars max*)</b><br>
<textarea name="permcc" rows="8" cols="60"></textarea>
<br>
<i>The following is about 95 characters:<br></i>
<pre>Dr CI MackenzieThe Family Surgery
	7 High Lower Green Street
	Orpington, Kent BR6 6BG</pre>
-->
<li class="submit"><input type="submit" style="color: green;" value="UPDATE PATIENT INFO" /></li>
</ul>
</fieldset>
</form>
<br>
<i>*For reference, the following is about 85 characters:<br></i>
<pre>
Dr Rufus T. Firefly
The Family Surgery
7 Horsefeathers Road
Grimsby, Grim GR1M SBY</pre>