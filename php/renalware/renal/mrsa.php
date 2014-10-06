<?php
//----Sat 14 May 2011----
//handle POSTs
if ($post_runmode=="addmrsadata") {
	$omitfields=array('runmode','swabsite','othersite');
	//construct site
	$swabsite = ($post_swabsite=="other--specify below") ? $mysqli->real_escape_string($post_othersite) : $post_swabsite ;
	$insertfields="swabuid,swabuser,swabadddate,swabsite";
	$insertvalues="$uid,'$user',CURDATE(),'$swabsite'";
	if ($post_swabresult) {
		$insertfields.=",resultuser,resultstamp";
		$insertvalues.=",'$user',NOW()";			
	}
	foreach ($_POST as $key => $value) {
		if ($value!="" && !in_array($key,$omitfields)) {
			$valfix = $mysqli->real_escape_string($value);
			if (substr($key,-4)=="date") {
				$valfix=fixDate($valfix);
			}
			$insertfields.=",$key";
			$insertvalues.=",'$valfix'";			
		}
	}
	$sql = "INSERT INTO renalware.mrsadata ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
	$newmrsa_id = $mysqli->insert_id;
	
	//log the event
	$eventtype="MRSA swab data ID $newmrsa_id added by $user";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//upd pat
	$sql = "UPDATE patientdata SET modifstamp=NOW(), lasteventstamp=NOW(),lasteventdate=NOW(),lasteventuser='$user' WHERE patzid=$zid";
	$result = $mysqli->query($sql);
	//upd renal
	if ($swabresult=="POS") {
		//----Wed 21 Sep 2011----set mrsaposflag & date
		$sql = "UPDATE renaldata SET renalmodifstamp=NOW(), mrsalast_id=$newmrsa_id,mrsaflag='Y',mrsadate='$swabdate',mrsasite='$swabsite', mrsaposflag='Y', mrsaposdate='$swabdate' WHERE renalzid=$zid";
	} else {
		//just flag has been done
		$sql = "UPDATE renaldata SET renalmodifstamp=NOW(), mrsalast_id=$newmrsa_id, mrsaflag='Y',mrsadate='$swabdate',mrsasite='$swabsite' WHERE renalzid=$zid";
	}
	$result = $mysqli->query($sql);
}
if ($post_runmode=="updmrsadata") {
	$updatepairs="resultstamp=NOW(),resultuser='$user'";
	foreach ($_POST as $key => $value) {
		if ($key!="runmode") {
			$valfix = $mysqli->real_escape_string($value);
			if (substr($key,-4)=="date") {
				$valfix=fixDate($valfix);
			}
			$updatepairs.=",$key='$valfix'";
		}
	}
	$sql = "UPDATE renalware.mrsadata SET $updatepairs WHERE mrsa_id=$post_mrsa_id";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="MRSA swab data ID $post_mrsa_id ($swabresult) updated by $user";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//upd pat
	$sql = "UPDATE patientdata SET modifstamp=NOW(), lasteventstamp=NOW(),lasteventdate=NOW(),lasteventuser='$user' WHERE patzid=$zid";
	$result = $mysqli->query($sql);
	//upd renal
	$updfields="renalmodifstamp=NOW(), mrsaflag='Y',mrsadate='$swabdate',mrsasite='$swabsite'";
	if ($swabresult=="POS") {
		$updfields="renalmodifstamp=NOW(), mrsaflag='Y',mrsadate='$swabdate',mrsasite='$swabsite',mrsaposflag='Y', mrsaposdate='$swabdate'";
	}
	$sql = "UPDATE renaldata SET $updfields WHERE renalzid=$zid";
	$result = $mysqli->query($sql);
	//echo "<br />TEST: $sql <br />";
}
//maps
include 'config/mrsa_config.php';
?>
<div id="ajax_alerts" style="display: none;"></div>
<!-- start ui tabs -->
<div id="uitabs">
	<ul>
			<li><a href="#mrsadatatab">MRSA Swabs History</a></li>
			<li><a href="#addmrsadataformtab">New MRSA Swab Entry</a></li>
	</ul>
	<div id="mrsadatatab">
		<div id="portaldiv">
			<?php
			include 'portals/mrsaportal.php';
			?>
		</div>
			<div id="showdatadiv"></div>
	</div>
	<div id="addmrsadataformtab">
		<form action="renal/renal.php?scr=mrsa&amp;zid=<?php echo $zid ?>" method="post" accept-charset="utf-8">
			<input type="hidden" name="runmode" value="addmrsadata" />
			<input type="hidden" name="mrsazid" value="<?php echo $zid ?>" />
			<fieldset>
				<legend>Add MRSA Swab data for <?php echo "$title $lastname" ?></legend>
				<ul class="form">
				<?php
				//----Thu 24 Feb 2011----
				$datamap=$mrsa_adddatamap;
				include 'incl/makeaddfields_incl.php';
				?>
				<li class="submit"><input type="submit" style="color: green;" value="Submit data&rarr;" /></li>
				</ul>
			</fieldset>
		</form>
	</div>

</div> 
<!-- end ui-tabs div -->
<script charset="utf-8">
	function goTabX(tabno) {
		$('#uitabs').tabs().tabs('select', tabno)
	}
	function getMRSA(this_id){
		//$('#portaldiv').hide();
		$('#showdatadiv').show();
		$.get("renal/ajax/get_mrsadata.php", {mrsa_id: this_id},
		   function(data){
			$('#showdatadiv').html(data);	   
			});
		}
	function hideMRSA(){
		$('#portaldiv').show();
		$('#showdatadiv').hide();
		}
</script>