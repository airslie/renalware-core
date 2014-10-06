<?php
include '../req/confcheckfxns.php';
$zid = $_GET['zid'];
$letter_id = $_GET['letter_id'];
$lettercc_id = $_GET['lettercc_id'];
$sender_id = $_GET['sender_id'];
include "$rwarepath/letters/data/letterdata.php";
$pagetitle= 'READ ' . $lettdescr . '(CC version) [' . $letterdate . '] ' . htmlspecialchars($patlastfirst, ENT_QUOTES) . ' (' . $letthospno . ', ' . $modalstamp . ')';
//log the event?
$eventtype="CC Letter ID $letter_id ($lettdescr) VIEWED by $user";
include "$rwarepath/run/logevent.php";
include "$rwarepath/parts/head_letter.php";
include "$rwarepath/letters/lettersites.php";
$showstatus=true; //not PRINT //should be ARCHIVED for CC version
$showsig=true; //show
include "$rwarepath/letters/incl/letter2html.php";
?>
<form action="<?php echo $rwareroot ?>/letters/run/run_markccletter.php" method="post" accept-charset="utf-8">
	<fieldset>
		<legend>Update Letter CC Status (Read/Unread)</legend>
<input type="hidden" name="cc_uid" value="<?php echo $uid ?>" id="cc_uid" />
<input type="hidden" name="lettercc_id" value="<?php echo $lettercc_id ?>" id="lettercc_id" />
<input type="hidden" name="author_id" value="<?php echo $authorid ?>" id="author_id" />
<input type="hidden" name="reader_id" value="<?php echo $uid ?>" id="reader_id" />
<input type="hidden" name="readeruser" value="<?php echo $user ?>" id="readeruser" />
<input type="hidden" name="letterzid" value="<?php echo $letterzid ?>" id="letterzid" />
<input type="radio" name="readstatus" value="read" checked="checked" />Read (remove from Inbox) &nbsp; &nbsp; <input type="radio" name="readstatus" value="unread" />Unread (Keep in CC Inbox)
<br><input type="checkbox" name="confirmread" value="y" /><b>Confirm</b> -- I have read this letter.<br>
<input type="checkbox" name="responseflag" value="y" />OPTIONAL--<b>Send message to Letter Author</b> (<?php echo $authorsig ?>):<br>
<input type="text" name="responsesubj" value="<?php echo "Re: Your letter of $letterdate: $lettdescr ($patlastfirst)";  ?>" id="responsesubj" size="100"/><br>
<b>URGENT?</b><input type="radio" name="urgentflag" value="0" checked="checked" />No &nbsp; &nbsp; <input type="radio" name="urgentflag" value="1" />Yes <br>
<textarea name="responsetext" rows="8" cols="100"></textarea><br>
<input type="submit" style="color: green;" value="Continue &rArr;" />
	</fieldset>
</form>
</body>
</html>
<?php
//for pageview logs Wed Nov 21 13:17:42 CET 2007
include "$rwarepath/incl/logpageview.php";
