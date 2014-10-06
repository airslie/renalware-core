<?php
//----Fri 22 Nov 2013----fix toggle Day Notes form
//----Fri 01 Feb 2013----daysurgslots DEPR bug fix
//handle daynotes update
if ($_POST['mode']=='updatenote') {
$diarydate=$_GET['ymd'];
$newdaynotes = $mysqli->real_escape_string($_POST["daynotes"]);
$sql="UPDATE diarydates SET daynotes='$newdaynotes', modifstamp=NOW() WHERE diarydate='$diarydate'";
$result = $mysqli->query($sql);
}

//default
$searchday=$todayymd;
if ( $_GET['ymd'] )
{
	$searchday=$_GET['ymd'];
}

if ( $_GET['dmy'] )
{
	$dmy=$_GET['dmy'];
	$ymd=fixDate($dmy);
	$searchday=$ymd;
}
//well get diarydate info first
$where="WHERE diarydate='$searchday'";
$fields="
diarydate, daynotes,
DATE_FORMAT(diarydate, '%a %d %b %Y') AS diarydate_ddmy,
availslots,
freeslots";
$tables="diarydates d";
$sql="SELECT $fields FROM $tables $where LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$diarydate_ddmy=$row["diarydate_ddmy"];
$daynotes=nl2br($row["daynotes"]);
$availslots=$row["availslots"];
$dayfreeslots=$row["freeslots"];
if (stristr($availslots,'E')) {
$emergslotavail=TRUE;
}
?>
<div id="minical">
	<?php
	include( 'incl/3months_scroll.php' );
	?>
</div>
<div id="diaryinfo">
	<div id="diarydatediv"><?php echo $diarydate_ddmy; ?></div>
	<p><button onclick="$('#daynotesform').show();">edit day notes</button>
		<?php
		$hostname=$_SERVER['HTTP_HOST'];
		if ($_GET['pending']!='show')
		{
		echo '&nbsp;&nbsp;&nbsp;<a class="button" href="index.php?vw=glance&amp;scr=dayview&ymd=' . $searchday . '&pending=show" >edit diary/show pending</a>';
		}
		else
		{
		echo '&nbsp;&nbsp;&nbsp;<a class="button" href="index.php?vw=glance&amp;scr=dayview&ymd=' . $searchday . '&pending=hide" >hide pending</a></p>';
		}
		?>
	</p>
	<?php if ($daynotes): ?>
		<div class="daynotes"><?php echo $daynotes; ?></div>
	<?php endif ?>
	<div id="daynotesform" style="display:none;">
	<form action="index.php?vw=glance&amp;scr=dayview&amp;ymd=<?php echo $searchday; ?>" method="post">
	<input type="hidden" name="mode" value="updatenote" id="mode" />
	<textarea name="daynotes" rows="18" cols="100"><?php echo str_replace('<br>', "",$daynotes); ?></textarea><br>
	<input type="submit" <button style="color: green;" value="Update Notes for <?php echo $diarydate_ddmy; ?>"> or <button style="color: red;" onclick="$('#daynotesform').hide();">CANCEL (hide form)</button>
	</form>
	</div>
	<h3>Admissions</h3>
	<?php
		include( 'glance/admdaylist_incl.php' );
	?>
	<h3>Procedures/Operations</h3>
	<?php
		include( 'glance/surgdaylist_incl.php' );
	if ( $_GET['pending']=='show' )
	{
		include( 'glance/pending_incl.php' );
	}
	?>	
</div>