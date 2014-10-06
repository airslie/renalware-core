<?php
//----Thu 01 Jul 2010---- jq UI trial
?>
<div id="sendmessagedialog">
	<form action="pat/run/run_sendmessage.php" method="post" accept-charset="utf-8">
		<input type="hidden" name="runform" value="sendmsg" id="runform" />
		<input type="hidden" name="message_uid" value="<?php echo $uid ?>" id="message_uid" />
		<input type="hidden" name="messageuser" value="<?php echo $user ?>" id="messageuser" />
		<input type="hidden" name="messagezid" value="<?php echo $zid ?>" id="messagezid" />
			<ul class="form">
				<li><b>Note: use control-click [Mac: cmd-click] to select more than one recipient</b></li>
			<li><label>Recipient(s)</label><select name="recipuids[]" id="recipuids" multiple size="5">
				<?php
		//get prior recips for this zid
		$sql = "SELECT DISTINCT recip_uid, CONCAT(userlast,', ',userfirst) as stafflastfirst, position FROM messagedata JOIN userdata ON recip_uid=uid WHERE messagezid=$zid AND expiredflag='0' ORDER BY userlast,userfirst";
		$result = $mysqli->query($sql);
		$numrows=$result->num_rows;
		if ($numrows) {
			echo '<optgroup label="Previous patient recips">';
			while($row = $result->fetch_assoc())
				{
					echo '<option value="'.$row["recip_uid"].'">'.$row["stafflastfirst"].', '.$row["position"].'</option>';
				}
			echo '</optgroup>';
		}
		$result->close();
		//get prior recips for this user
		$sql = "SELECT DISTINCT recip_uid, CONCAT(userlast,', ',userfirst) as stafflastfirst, position FROM messagedata JOIN userdata ON recip_uid=uid WHERE message_uid=$uid AND expiredflag='0' ORDER BY userlast,userfirst";
		$result = $mysqli->query($sql);
		$numrows=$result->num_rows;
		if ($numrows) {
			echo '<optgroup label="Previous '.$user.' recips">';
			while($row = $result->fetch_assoc())
				{
					echo '<option value="'.$row["recip_uid"].'">'.$row["stafflastfirst"].', '.$row["position"].'</option>';
				}
			echo '</optgroup>';
		}
		$result->close();
		$sql = "SELECT uid, userlast, userfirst, position FROM userdata WHERE expiredflag='0' ORDER BY userlast, userfirst";
		$result = $mysqli->query($sql);
		echo '<optgroup label="Current '.$siteshort.' Staff">';
		while($row = $result->fetch_assoc())
			{
				echo '<option value="'.$row["uid"].'">'.$row["userlast"].', '.$row["userfirst"].', '.$row["position"].'</option>';
			}
		$result->close();
		echo '</optgroup>';
		?></select></li>
<li><label>Urgent?</label>&nbsp;&nbsp;<input type="radio" name="urgentflag" id="urgentflag0" value="0" checked="checked" /><label for="urgentflag0">No</label>&nbsp;&nbsp;<input type="radio" name="urgentflag" id="urgentflag1" value="1" /><label for="urgentflag1">YES</label></li>&nbsp;
<?php
inputText("messagesubj", "Subject",100,$page);
inputnewTextarea("messagetext", "Message Text",5,100);
?>
<li class="submit"><input type="submit" style="color: green;" value="Send &rarr;"/></li>
</ul>
</form>
</div>
<script type="text/javascript">
  jQuery(document).ready(function() {
    jQuery("#dialog").dialog({
      bgiframe: true, autoOpen: false, height: 400, width: 500, modal: true
    });
  });
</script>
<a href="#" class="ui-state-default" style="color: purple;" onclick="jQuery('#sendmessagedialog').dialog('open'); return false">Send Msg!</a>
