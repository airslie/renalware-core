<?php
if ($get_update=="linechangedate") {
	$linechangedate=fixDate($post_linechangedate);
	$sql = "UPDATE renaldata SET renalmodifstamp=NOW(), pdlinechangedate='$linechangedate' WHERE renalzid=$zid";
	$result = $mysqli->query($sql);
	showAlert("The line change due date was updated!");
	//refresh
	include '../data/renaldata.php';
}
?>
<table border="0">
	<tr>
		<td valign="top">
			<p class="header">Next Line Change Date <a class="btn" onclick="$('#updlinechangedate').toggle()">Update</a></p>
			<ul class="portal">
				<li><label class="displ">Next change date</label>&nbsp;&nbsp;<?php echo $pdlinechangedate ?></li>
			</ul>
			<div id="updlinechangedate" style="display: none;">
			<form action="renal/renal.php?zid=<?php echo $zid ?>&amp;scr=pd&amp;update=linechangedate" method="post" accept-charset="utf-8">
				<?php picklabelDate('linechangedate',$pdlinechangedate) ?><br>
				<input type="submit" class="gr" value="Update Line Change Due Date"></p>
			</form>
			</div>
		</td>
		<td valign="top">
			<p class="header">PET/Adequacy data <a class="btn" href="renal/forms/petadeqdataform.php?zid=<?php echo $zid ?>">add/update</a></p>
			<ul class="portal">
			<?php
			include 'pd/petadeq_incl.php';
			?>
			</ul>
		</td>
<?php
switch ($modalcode) {
	case 'PD_APD':
		include 'pd/apdrx_incl.php';
		break;
	case 'PD_assistedAPD':
		include 'pd/apdrx_incl.php';
		break;
	case 'PD_CAPD':
		include 'pd/capdrx_incl.php';
		break;
}
?>
	</tr>
</table>
<?php
//portals
include('pd/peritonitisdata_portal.php');
include('pd/exitsitedata_portal.php');
include('pd/petadeqdata_portal.php');
include('pd/apdrxdata_portal.php');
include('pd/capdrxdata_portal.php');
?>