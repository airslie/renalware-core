<?php
//for default date
$showtoday=date("d/m/Y");
$fromurl = ($get_fromscr) ? "renal/renal.php?scr=$get_fromscr&amp;zid=$zid" : "pat/patient.php?vw=$get_fromvw&amp;zid=$zid" ;
?>
<form action="<?php echo $fromurl ?>" method="post" accept-charset="utf-8">
			<input type="hidden" name="mode" value="runmsg" />
			<input type="hidden" name="message_uid" value="<?php echo $uid ?>" />
			<input type="hidden" name="messageuser" value="<?php echo $user ?>" />
			<input type="hidden" name="messagezid" value="<?php echo $zid ?>" />
			<fieldset>
				<legend>Send <?php echo $siteshort ?> message</legend>
				<ul class="form">
					<li><b>Note: use control-click [Mac: cmd-click] to select more than one recipient</b></li>
				<li><label>Recipient(s)</label><select name="recipuids[]" id="recipuids" multiple size="10">
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
	<li><label>Urgent?</label>&nbsp;&nbsp;<input type="radio" name="urgentflag" id="urgentflag0" value="0" checked="checked" /><b>No</b>&nbsp;&nbsp;<input type="radio" name="urgentflag" id="urgentflag1" value="1" /><b>YES</b></li>&nbsp;
	<?php
	inputText("messagesubj", "Subject",100,$pagetitle);
	inputnewTextarea("messagetext", "Message Text",6,100);
	?>
	<li class="submit"><input type="submit" style="color: green;" value="Send &rarr;"/>&nbsp;&nbsp;
			<a class="ui-state-default" style="color: red;" href="<?php echo $fromurl ?>">cancel</a></li>
	</ul>
	</fieldset>
	</form>