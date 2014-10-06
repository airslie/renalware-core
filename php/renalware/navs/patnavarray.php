<?php
//----Sun 08 Dec 2013----alert d/m/Y display
//to handle new msgs
if ($post_mode=="runmsg") {
	$recipuidsarray=$_POST['recipuids'];
	$messagesubj = $mysqli->real_escape_string($_POST["messagesubj"]);
	$messagetext = $mysqli->real_escape_string($_POST["messagetext"]);
	$uidlist="";
	foreach ($recipuidsarray as $key => $recip_uid) {
		$insertfields="message_uid, messageuser, recip_uid,messagezid,messagesubj,messagetext,urgentflag";
		$insertvalues="$post_message_uid, '$post_messageuser',$recip_uid,$post_messagezid,'$messagesubj','$messagetext','$post_urgentflag'";
		$sql = "INSERT INTO renalware.messagedata ($insertfields) VALUES ($insertvalues)";
		$mysqli->query($sql);
		$uidlist.="$recip_uid ";
	}
	$runmsgtxt="Your message re: $messagesubj has been sent.";
	showAlert("$runmsgtxt");
	//log the event
		$eventtype="$messagesubj sent by UID $uid to UIDs $uidlist";
		$eventtext=$messagetext;
		include "$rwarepath/run/logevent.php";
}
$patnav = array (
	'admin' => 'Admin',
	'clinsumm' => 'ClinSumm',
	'admissions' => "Adm&rsquo;ns $count_admissions",
	'pimsdata' => "PIMS",
	'letters' => "Lttrs $count_letters",
	'encounters' => "Encs $count_encounters",
	'meds' => "Meds $count_meds",
	'problems' => "Probs $count_probs",
	'modals' => "Modals $count_modals",
	'bpwtdata' => "Ht/BP/Wt $count_bpwts",
	'ixworkups' => "Ix $count_ixdata",
	'pathology' => "Path $count_pathix",
	'proceds' => "Ops $count_ops",
	'psychsocial' => "Psych/Soc",
//	'hl7events' => "PIMS $count_events"
	);
if ($screentype=='narrow') 
	{
	$patnav = array (
		'admin' => 'Admin',
		'clinsumm' => 'ClinSumm',
		'admissions' => "Adm&rsquo;ns",
		'pimsdata' => "PIMS",
		'letters' => "Lttrs",
		'encounters' => "Encs",
		'meds' => "Meds",
		'problems' => "Probs",
		'modals' => "Modals",
		'bpwtdata' => "Ht/BP/Wt",
		'ixworkups' => "Ix",
		'pathology' => "Pathol",
		'proceds' => "Ops",
		'psychsocial' => "Psych/Social",
		'hl7events' => "PIMS"
		);
	}
//$pagetitle= $patnav[$vw] . ' -- ' . $titlestring;
//set mod to select vwbar options
$baseurl="pat/patient.php?zid=$zid";
//navbar
?>
<div class="buttonsdiv noprint">
	<?php
	foreach ($patnav as $key => $value) {
		$class = ($key==$vw) ? ' class="hilit"' : "" ;
		echo '<a'.$class.' href="pat/patient.php?vw=' . $key . '&amp;zid=' . $zid . '">' . $value . '</a>';
		}
	?>
<a href="pat/patient.php?vw=editmeds&amp;zid=<?php echo $zid; ?>">Edit Meds</a>
<a href="letters/createletter.php?zid=<?php echo $zid; ?>">New Letter</a>
<a onclick='$("#bookmark").toggle();'>&rsquo;Bkmark&lsquo;</a>
<a onclick='$("#editalert").toggle();'>&rsquo;Alert&lsquo;</a>
<a href="pat/patient.php?vw=sendmsg&amp;zid=<?php echo $zid; ?>&amp;fromvw=<?php echo $vw ?>&amp;fromscr=<?php echo $scr ?>">&rsquo;Msg&lsquo;</a>
</div>
<?php
if ($mode=="runbookmark") {
	$sql = "INSERT INTO bookmarkdata (markzid, markuid, marklist, marknotes, markstamp, markpriority) VALUES ($zid, $uid, '$post_marklist', '$post_marknotes', NOW(), '$post_markpriority')";
	$result = $mysqli->query($sql);
	showAlert("Your bookmark has been added!");
	}
?>
<div id="bookmark" style="display:none;">
	<form action="<?php echo $thisurl ?>&amp;mode=runbookmark" method="post" accept-charset="utf-8"><fieldset>
	List (optional)<input type="text" name="marklist" size="15" />&nbsp;&nbsp;
	Notes (optional)<input type="text" name="marknotes" size="50" id="marknotes" />&nbsp;&nbsp;
	Priority <input type="radio" name="markpriority" value="Normal" checked="checked" />Normal &nbsp; &nbsp; <input type="radio" name="markpriority" value="URGENT" />URGENT
	<input type="submit" style="color: green;" value="bookmark patient" /></fieldset>
	</form>	
</div>
<?php
if ($mode=="runalert") {
	if ($post_alerttext) {
        $alertdmy=date("d/m/Y");
		$newalert=$post_alerttext . " [$user $alertdmy]";
		$sql = "UPDATE patientdata SET modifstamp=NOW(), alert='$newalert' WHERE patzid=$zid";
		$eventtype="Alert edited by UID $uid ($user)";
		$eventtext=$newalert;
	} else {
		$sql = "UPDATE patientdata SET modifstamp=NOW(), alert=NULL WHERE patzid=$zid";
		$eventtype="Alert deleted by UID $uid ($user)";
		$eventtext="Prev alert: $alert"; //keep old one
	}
	$result = $mysqli->query($sql);
	include "$rwarepath/run/logevent.php";
	//refresh
	$sql = "SELECT alert FROM patientdata WHERE patzid=$zid";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$alert=$row["alert"];
	}
//for fast delete
if ($mode=="deletealert") {
		$sql = "UPDATE patientdata SET modifstamp=NOW(), alert=NULL WHERE patzid=$zid";
		$eventtype="Alert deleted by UID $uid ($user)";
		$eventtext="Prev alert: $alert"; //keep old one
	$result = $mysqli->query($sql);
	include "$rwarepath/run/logevent.php";
	//refresh
	$alert=FALSE;
	}
?>
<div id="editalert" style="display:none;">
	<form action="<?php echo $thisurl ?>&amp;mode=runalert" method="post" accept-charset="utf-8">
<fieldset>Patient &rsquo;Alert&lsquo; text (max 250 char; appears under Allergies when filled in <br>
	<input type="text" name="alerttext" value="<?php echo $alert ?>" size="100" id="alerttext" />&nbsp;&nbsp;
	<input type="submit" style="color: green;" value="add &rsquo;Alert&lsquo;" id="submitalert" />&nbsp;&nbsp;
	<a class="ui-state-default" style="color: red;" onclick='$("#editalert").toggle();'>cancel</a> or <a class="ui-state-default" style="color: purple;" href="<?php echo $thisurl ?>&amp;mode=deletealert">delete alert</a>
</fieldset></form>	
</div>