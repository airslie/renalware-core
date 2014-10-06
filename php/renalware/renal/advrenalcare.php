<?php
//----Mon 27 Aug 2012----fix for broken portals
//----Wed 27 Oct 2010----
//handle POSTs
if ($post_runmode=="addarcdata") {
	$insertfields="arcmodifstamp,arcuser,arcadddate,arcuid";
	$insertvalues="NOW(),'$user',NOW(),$uid";
	foreach ($_POST as $key => $value) {
		if ($value!="" && $key!="runmode") {
			$valfix = $mysqli->real_escape_string($value);
			if (substr($key,-4)=="date") {
				$valfix=fixDate($valfix);
			}
			$insertfields.=",$key";
			$insertvalues.=",'$valfix'";			
		}
	}
	$sql = "INSERT INTO renalware.arcdata ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="ARC data added by $user";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//upd pat
	$sql = "UPDATE patientdata SET modifstamp=NOW(), lasteventstamp=NOW(),lasteventdate=NOW(),lasteventuser='$user' WHERE patzid=$zid";
	$result = $mysqli->query($sql);	
}
if ($post_runmode=="updarcdata") {
	$updatepairs="arcmodifstamp=NOW(),arcuser='$user'";
	foreach ($_POST as $key => $value) {
		if ($key!="runmode") {
			$valfix = $mysqli->real_escape_string($value);
			if (substr($key,-4)=="date") {
				$valfix=fixDate($valfix);
			}
			$updatepairs.=",$key='$valfix'";
		}
	}
	$sql = "UPDATE renalware.arcdata SET $updatepairs WHERE arczid=$zid";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="ARC data updated by $user";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//upd pat
	$sql = "UPDATE patientdata SET modifstamp=NOW(), lasteventstamp=NOW(),lasteventdate=NOW(),lasteventuser='$user' WHERE patzid=$zid";
	$result = $mysqli->query($sql);	
}
//----Thu 24 Feb 2011----NB no updates of these questionnaires, INSERT only
if ($post_runmode=="addeq5ddata") {
	$insertfields="eq5duser,eq5dadddate";
	$insertvalues="'$user',NOW()";
	foreach ($_POST as $key => $value) {
		if ($value!="" && $key!="runmode") {
			$valfix = $mysqli->real_escape_string($value);
			if (substr($key,-4)=="date") {
				$valfix=fixDate($valfix);
			}
			$insertfields.=",$key";
			$insertvalues.=",'$valfix'";			
		}
	}
	$sql = "INSERT INTO renalware.arc_eq5ddata ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="ARC EQ-5D (health state) questionnaire data added by $user";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//upd pat
	$sql = "UPDATE patientdata SET modifstamp=NOW(), lasteventstamp=NOW(),lasteventdate=NOW(),lasteventuser='$user' WHERE patzid=$zid";
	$result = $mysqli->query($sql);	
}
//----Fri 11 Mar 2011----
if ($post_runmode=="addpossdata") {
	$insertfields="possuser,possadddate";
	$insertvalues="'$user',NOW()";
	foreach ($_POST as $key => $value) {
		if ($value!="" && $key!="runmode") {
			$valfix = $mysqli->real_escape_string($value);
			if (substr($key,-4)=="date") {
				$valfix=fixDate($valfix);
			}
			$insertfields.=",$key";
			$insertvalues.=",'$valfix'";			
		}
	}
	$sql = "INSERT INTO renalware.arc_possdata2 ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
	$newposs_id = $mysqli->insert_id;
	//total POSS score
	$sql = "UPDATE arc_possdata2 SET totalposs_score = IFNULL(pain,0) + IFNULL(shortness_of_breath,0) + IFNULL(weakness,0) + IFNULL(nausea,0) + IFNULL(vomiting,0) + IFNULL(poor_appetite,0) + IFNULL(constipation,0) + IFNULL(mouth_problems,0) + IFNULL(drowsiness,0) + IFNULL(poor_mobility,0) + IFNULL(itching,0) + IFNULL(insomnia,0) + IFNULL(restless_legs,0) + IFNULL(anxiety,0) + IFNULL(depression,0) + IFNULL(skinchanges,0) + IFNULL(diarrhoea,0) + IFNULL(othersymptom1score,0) + IFNULL(othersymptom2score,0) + IFNULL(othersymptom3score,0) WHERE poss_id=$newposs_id LIMIT 1";
	$result = $mysqli->query($sql);
	
	//log the event
	$eventtype="ARC POS-S (symptoms) questionnaire data added by $user";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//upd pat
	$sql = "UPDATE patientdata SET modifstamp=NOW(), lasteventstamp=NOW(),lasteventdate=NOW(),lasteventuser='$user' WHERE patzid=$zid";
	$result = $mysqli->query($sql);	
}

//----Sun 11 Jul 2010----
//maps
include 'arc/arc_config.php';
//get ARC data
$showarcdataflag=FALSE;
$table="arcdata";
$zidfield="arczid";
$sql = "SELECT * FROM $table WHERE $zidfield=$zid";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	$showarcdataflag=TRUE;
	$row = $result->fetch_assoc();
	foreach ($row as $key => $value) {
		$$key = (substr($key,-4)=="date") ? dmy($value) : $value ;
	}
}
//EQ5D
// IMPORTANT may be more than 1 so just get latest
$table="arc_eq5ddata";
$zidfield="eq5dzid";
$sql = "SELECT * FROM $table WHERE $zidfield=$zid ORDER BY eq5d_id DESC LIMIT 1";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	$showeq5ddataflag=TRUE;
	$row = $result->fetch_assoc();
	foreach ($row as $key => $value) {
		$$key = (substr($key,-4)=="date") ? dmy($value) : $value ;
	}
} else {
	$showeq5ddataflag=FALSE;
}
//POSS
// IMPORTANT may be more than 1 so just get latest
$table="arc_possdata2";
$zidfield="posszid";
$sql = "SELECT * FROM $table WHERE $zidfield=$zid ORDER BY poss_id DESC LIMIT 1";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	$showpossdataflag=TRUE;
	$row = $result->fetch_assoc();
	foreach ($row as $key => $value) {
		$$key = (substr($key,-4)=="date") ? dmy($value) : $value ;
	}
} else {
	$showpossdataflag=FALSE;
}

?>
<div id="ajax_alerts" style="display: none;"></div>
<!-- start ui tabs -->
<div id="uitabs">
	<ul>
		<li><a href="#showarcdatatab">ARC/EQ-5D/POS-S Summary</a></li>
		<?php if ($showarcdataflag): ?>
			<li><a href="#updarcdataformtab">Update ARC data</a></li>
		<?php else: ?>
			<li><a href="#addarcdataformtab">Add ARC data</a></li>
		<?php endif ?>
		<?php if ($showeq5ddataflag): ?>
			<li><a href="#showeq5ddatatab">View EQ-5D data</a></li>
		<?php endif ?>
		<li><a href="#eq5ddataformtab">Enter EQ-5D data</a></li>
		<?php if ($showpossdataflag): ?>
			<li><a href="#showpossdatatab">View POS-S data</a></li>
		<?php endif ?>
		<li><a href="#possdataformtab">Enter POS-S data</a></li>
	</ul>
		<!-- show ARC data -->
		<div id="showarcdatatab">
			<h3>Latest EQ-5D</h3>
			<?php
			$latestflag=TRUE;
			include 'portals/arc_eq5dportal.php';
			?>
			<h3>Latest POS-S</h3>
			<?php
			$latestflag=TRUE;
			include 'portals/arc_possnumportal.php';
			?>
			
			<h3>ARC Status</h3>
			<p><?php echo '<b>Last updated</b>: '.$arcmodifstamp.' by '.$arcuser ?></p>
			<?php
			//----Thu 24 Feb 2011----for renaldx
			$arcdiagnosis=$EDTAtext;
			$showfields=$showarcfields;
			include 'incl/showfields2ul.php';
			?>
		</div>
	<?php if ($showarcdataflag): ?>
		<!-- update ARC data -->
		<div id="updarcdataformtab">
			<form action="renal/renal.php?scr=advrenalcare&amp;zid=<?php echo $zid ?>" method="post" accept-charset="utf-8">
				<input type="hidden" name="runmode" value="updarcdata" />
				<input type="hidden" name="arczid" value="<?php echo $zid ?>" />
				<fieldset>
					<legend>Update Advanced Renal Care data for <?php echo "$title $lastname" ?></legend>
					<ul class="form">
					<?php
					$datamap=$arcdatamap;
					include 'incl/makeupdfields_incl.php';
					?>	
					<li class="submit">
						<input type="submit" style="color: green;" value="Update ARC data &rarr;" />&nbsp;&nbsp;
						<input type="button" class="ui-state-default" style="color: red;" onclick="javascript:goTabX(0)" value="Cancel" />
					</li>
					</ul>
				</fieldset>
			</form>
		</div>
<?php else: ?>
	<!-- no ARC data yet so add only -->
	<div id="addarcdataformtab">
		<form action="renal/renal.php?scr=advrenalcare&amp;zid=<?php echo $zid ?>" method="post" accept-charset="utf-8">
			<input type="hidden" name="runmode" value="addarcdata" />
			<input type="hidden" name="arczid" value="<?php echo $zid ?>" />
			<fieldset>
				<legend>Add Advanced Renal Care data for <?php echo "$title $lastname" ?></legend>
				<ul class="form">
				<?php
				//----Thu 24 Feb 2011----
				$datamap=$arcdatamap;
				include 'incl/makeaddfields_incl.php';
				?>
				<li class="submit"><input type="submit" style="color: green;" value="Submit data&rarr;" /></li>
				</ul>
			</fieldset>
		</form>
	</div>
<?php endif ?>
<?php if ($showeq5ddataflag): ?>
	<div id="showeq5ddatatab">
		<div id="latesteq5ddiv">
			<h3>Latest EQ-5D Data</h3>
		<?php
		$showfields=$showeq5ddatafields;
		include 'incl/showfields2ul.php';
		?>
		</div>
		<h3>EQ-5D Surveys List (Most recent at top)</h3>
		<?php
		$latestflag=false;
		include 'portals/arc_eq5dportal.php';
		?>
	</div>
<?php endif ?>
<?php if ($showpossdataflag): ?>
	<div id="showpossdatatab">
		<h3>POS-S Surveys (Most recent at top)</h3>
		<?php
		//include 'portals/arc_possportal.php';
		//2012-03-11 using new numeric scoring
		$latestflag=false;
		include 'portals/arc_possnumportal.php';
		?>
	</div>
<?php endif ?>

<!-- always allow new EQ-5D entry -->
	<div id="eq5ddataformtab">
		<form action="renal/renal.php?scr=advrenalcare&amp;zid=<?php echo $zid ?>" method="post" accept-charset="utf-8">
			<input type="hidden" name="runmode" value="addeq5ddata" />
			<input type="hidden" name="eq5dzid" value="<?php echo $zid ?>" />
			<input type="hidden" name="eq5duid" value="<?php echo $uid ?>" />
			<fieldset>
				<legend>Add EQ-5D data for <?php echo "$title $lastname" ?></legend>
			<ul class="form">
			<?php
			//----Thu 24 Feb 2011----
			$datamap=$eq5ddatamap;
			include 'incl/makeaddfields_incl.php';
			?>
			<li class="submit">
				<input type="submit" id="submit_eq5ddata" class="ui-state-default" style="color: green;" value="Submit data" />&nbsp;&nbsp;
				<input type="button" class="ui-state-default" style="color: red;" onclick="javascript:goTabX(0)" value="Cancel" />
				</li>
			</ul>
		</fieldset>
		</form>
	</div>
<!-- always allow new POSS entry -->
	<div id="possdataformtab">
		<form action="renal/renal.php?scr=advrenalcare&amp;zid=<?php echo $zid ?>" method="post" accept-charset="utf-8">
			<input type="hidden" name="runmode" value="addpossdata" />
			<input type="hidden" name="posszid" value="<?php echo $zid ?>" />
			<input type="hidden" name="possuid" value="<?php echo $uid ?>" />
			<fieldset>
				<legend>Add POS-S data for <?php echo "$title $lastname" ?></legend>
			<p><b>Key</b>: 0--Not at all&nbsp;&nbsp;1--Slightly&nbsp;&nbsp;2--Moderately&nbsp;&nbsp;3--Severely&nbsp;&nbsp;4--Overwhelmingly <br><b>HINT</b>: Use 0,1,2,3,or 4 in the popups for fast option selection</p>
			<ul class="form" id='possdataset'>
			<?php
			//----Thu 24 Feb 2011----
			$datamap=$possdatamap;
			include 'incl/makeaddfields_incl.php';
			//NB SPECIALS BELOW
			
			?>
			<li class="submit">
				<input type="submit" id="submit_possdata" class="ui-state-default" style="color: green;" value="Submit data" />&nbsp;&nbsp;
				<input type="button" class="ui-state-default" style="color: red;" onclick="javascript:goTabX(0)" value="Cancel" />
				</li>
			</ul>
		</fieldset>
		</form>
	</div>
</div> 
<!-- end ui-tabs div -->
<script type="text/javascript">
	function goTabX(tabno) {
		$('#uitabs').tabs().tabs('select', tabno)
	}
	function getEQ5D(thiseq5did){
		$('#latesteq5ddiv').hide();
		$('#showeq5ddiv').show();
		$.get("renal/arc/get_eq5ddata.php", {eq5did: thiseq5did},
		   function(data){
			$('#showeq5ddatadiv').html(data);	   
			});
		}
	function hideEQ5D(){
		$('#latesteq5ddiv').show();
		$('#showeq5ddiv').hide();
		}
</script>
