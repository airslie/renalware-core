<?php
include "$rwarepath/data/patientdata.php";
?>
<button type="button" class="ui-state-default" onclick="location.href='pat/form.php?f=update_patient&amp;zid=<?php echo $zid; ?>'">Edit Admin Info</button>
<table class="ui-state-default" >
<tr><td valign="top">
<ul class="portal">
	<li class="hdr">PATIENT INFO</li>
	<li><b><?php echo $hosp1label; ?></b>&nbsp;&nbsp;<?php echo $hospno1; ?></li>
	<li><b><?php echo $hosp2label; ?></b>&nbsp;&nbsp;<?php echo $hospno2; ?></li>
	<li><b><?php echo $hosp3label; ?></b>&nbsp;&nbsp;<?php echo $hospno3; ?></li>
	<li><b><?php echo $hosp4label; ?></b>&nbsp;&nbsp;<?php echo $hospno4; ?></li>
	<li><b><?php echo $hosp5label; ?></b>&nbsp;&nbsp;<?php echo $hospno5; ?></li>
	<li><b>Hosp Ref No</b>&nbsp;&nbsp;<?php echo $hosprefno; ?></li>
	<li><b>NHS No</b>&nbsp;&nbsp;<?php echo $nhsno; ?></li>
	</ul>
	<ul class="portal">
		<li class="hdr">SYSTEM/ADMIN INFO</li>
		<li><b>Added by</b>&nbsp;&nbsp;<?php echo $adduser .' ('.$adduid.')'; ?></li>
		<li><b>Admin Notes</b>&nbsp;&nbsp;<br><?php echo nl2br($adminnotes); ?></li>
		<li><b>added</b>&nbsp;&nbsp;<?php echo $addstamp; ?></li>
		<li><b>updated</b>&nbsp;&nbsp;<?php echo $modifstamp; ?></li>
		</ul>
</td><td valign="top">
<ul class="portal">
	<li class="hdr">PATIENT DEMOGRAPHICS</li>
	<li><b>title</b>&nbsp;&nbsp;<?php echo $title; ?></li>
	<li><b>last name</b>&nbsp;&nbsp;<?php echo $lastname; ?></li>
	<li><b>first names</b>&nbsp;&nbsp;<?php echo $firstnames; ?></li>
	<li><b>suffix</b>&nbsp;&nbsp;<?php echo $suffix; ?></li>
	<li><b>sex</b>&nbsp;&nbsp;<?php echo $sex; ?></li>
	<li><b>DOB</b>&nbsp;&nbsp;<?php echo $birthdate; ?></li>
	<li><b>modalcode</b>&nbsp;&nbsp;<?php echo $modalcode . ' ' . $modalsite; ?></li>
	<li><b>Date of Death</b>&nbsp;&nbsp;<?php echo $deathdate; ?></li>
	<li><b>marital status</b>&nbsp;&nbsp;<?php echo $maritstatus; ?></li>
	<li><b>ethnicity</b>&nbsp;&nbsp;<?php echo $ethnicity; ?></li>
	<li><b>religion</b>&nbsp;&nbsp;<?php echo $religion; ?></li>
	<li><b>language</b>&nbsp;&nbsp;<?php echo $language; ?></li>
	<li class="hdr">LETTERS/CCs</li>
	<li><b>CC letters?</b>&nbsp;&nbsp;<?php echo $ccflag; ?></li>
	<li><b>CC date asked?</b>&nbsp;&nbsp;<?php echo $ccflagdate; ?></li>
	<li><b>Default CCs</b>&nbsp;&nbsp;<br><?php echo nl2br($defaultccs); ?></li>
	</ul>
</td><td valign="top">
<ul class="portal">
	<li class="hdr">PATIENT CONTACT INFO</li>
	<li><b>addr1</b>&nbsp;&nbsp;<?php echo $addr1; ?></li>
	<li><b>addr2</b>&nbsp;&nbsp;<?php echo $addr2; ?></li>
	<li><b>addr3</b>&nbsp;&nbsp;<?php echo $addr3; ?></li>
	<li><b>addr4</b>&nbsp;&nbsp;<?php echo $addr4; ?></li>
	<li><b>postcode</b>&nbsp;&nbsp;<?php echo $postcode; ?></li>
	<li><b>tel1</b>&nbsp;&nbsp;<?php echo $tel1; ?></li>
	<li><b>tel2</b>&nbsp;&nbsp;<?php echo $tel2; ?></li>
	<li><b>fax</b>&nbsp;&nbsp;<?php echo $fax; ?></li>
	<li><b>mobile</b>&nbsp;&nbsp;<?php echo $mobile; ?></li>
	<li><b>email</b>&nbsp;&nbsp;<?php
	if ( $email )
	{
		echo '<a href="mailto:' . $email . '">' . $email . '</a>';
	}
	?></li>
	<li><b>temp addr</b>&nbsp;&nbsp;<?php echo $tempaddr; ?></li>
	<li class="hdr">RENAL REGISTRY</li>
	<li><b>&lsquo;Opt Out&rsquo;?</b>&nbsp;&nbsp;<?php echo $renalregoptout; ?></li>
	<li><b>Date recorded</b>&nbsp;&nbsp;<?php echo $renalregdate; ?></li>
	</ul>
</td><td valign="top">
<ul class="portal">
	<li class="hdr">GP INFO</li>
	<li><b>GP name</b>&nbsp;&nbsp;<?php echo $gp_name; ?></li>
	<li><b>gp_natcode</b>&nbsp;&nbsp;<?php echo $gp_natcode; ?></li>
	<li><b>region</b>&nbsp;&nbsp;<?php echo $gp_region; ?></li>
	<li><b>addr1</b>&nbsp;&nbsp;<?php echo $gp_addr1; ?></li>
	<li><b>addr2</b>&nbsp;&nbsp;<?php echo $gp_addr2; ?></li>
	<li><b>addr3</b>&nbsp;&nbsp;<?php echo $gp_addr3; ?></li>
	<li><b>addr4</b>&nbsp;&nbsp;<?php echo $gp_addr4; ?></li>
	<li><b>postcode</b>&nbsp;&nbsp;<?php echo $gp_postcode; ?></li>
	<li><b>tel</b>&nbsp;&nbsp;<?php echo $gp_tel; ?></li>
	<li><b>fax</b>&nbsp;&nbsp;<?php echo $gp_fax; ?></li>
	<li><b>email</b>&nbsp;&nbsp;<?php
	if ( $gp_email )
	{
		echo '<a href="mailto:' . $gp_email . '">' . $gp_email . '</a>';
	}
	?></li>
	<li class="hdr">TRANSPORT INFO</li>
	<li><b>Needs Transport?</b>&nbsp;&nbsp;<?php echo $transportflag; ?></li>
	<li><b>Type</b>&nbsp;&nbsp;<?php echo $transporttype; ?></li>
	<li><b>Updated</b>&nbsp;&nbsp;<?php echo $transportdate; ?></li>
	<li><b>Decider</b>&nbsp;&nbsp;<?php echo $transportdecider; ?></li>
	<li class="hdr">IMMUNOSUPPRESSANTS</li>
	<li><b>Delivery</b>&nbsp;&nbsp;<?php echo $immunosuppdrugdelivery; ?></li>            
	</ul>
</td></tr>
<tr><td valign="top">
<ul class="portal">
	<li class="hdr">REFERRAL INFO</li>
	<li><b>Referral date</b>&nbsp;&nbsp;<?php echo $refer_date; ?></li>
	<li><b>Referred by</b>&nbsp;&nbsp;<?php echo $referrer; ?></li>
	<li><b>referral type</b>&nbsp;&nbsp;<?php echo $refer_type; ?></li>
	<li><b>referral notes</b>&nbsp;&nbsp;<?php echo $refer_notes; ?></li>
	</ul>
</td><td valign="top">
<ul class="portal">
	<li class="hdr">PHARMACIST INFO</li>
	<li><b>Pharmacist</b>&nbsp;&nbsp;<?php echo $pharmacist; ?></li>
	<li><b>Telephone</b>&nbsp;&nbsp;<?php echo $pharmacist_phone; ?></li>
	<li><b>Address</b>&nbsp;&nbsp;<br><?php echo nl2br($pharmacist_addr); ?></li>
	</ul>
<ul class="portal">
	<li class="hdr">DISTRICT NURSE INFO</li>
	<li><b>District Nurse</b>&nbsp;&nbsp;<?php echo $districtnurse; ?></li>
	<li><b>Telephone</b>&nbsp;&nbsp;<?php echo $districtnurse_phone; ?></li>
	<li><b>Address</b>&nbsp;&nbsp;<br><?php echo nl2br($districtnurse_addr); ?></li>
	</ul>
</td><td valign="top">
<ul class="portal">
	<li class="hdr">NEXT OF KIN INFO</li>
	<li><b>Next of Kin:</b>&nbsp;&nbsp;<?php echo $nok_name; ?></li>
	<li><b>addr1</b>&nbsp;&nbsp;<?php echo $nok_addr1; ?></li>
	<li><b>addr2</b>&nbsp;&nbsp;<?php echo $nok_addr2; ?></li>
	<li><b>addr3</b>&nbsp;&nbsp;<?php echo $nok_addr3; ?></li>
	<li><b>addr4</b>&nbsp;&nbsp;<?php echo $nok_addr4; ?></li>
	<li><b>postcode</b>&nbsp;&nbsp;<?php echo $nok_postcode; ?></li>
	<li><b>tels</b>&nbsp;&nbsp;<?php echo $nok_tels; ?></li>
	<li><b>email</b>&nbsp;&nbsp;<?php echo $nok_email; ?></li>
	<li><b>notes</b>&nbsp;&nbsp;<?php echo $nok_notes; ?></li>
</ul>
</td>
</tr>
</table>