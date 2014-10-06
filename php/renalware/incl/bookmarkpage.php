<?php
//try this
$thispage=$_SERVER['REQUEST_URI'];
$bookmarkurl=urlencode($thispage);
// if submitted...
if ($_POST['mode']=='bookmark')
	{
	$sql= "INSERT INTO bookmarkdata (bookmarkurl, bookmarkname, bookmarkuid, bookmarkstamp) VALUES ('$bookmarkurl', '$page', '$uid', NOW())";
$result = $mysqli->query($sql);
	}
?>
<form action="<?php echo $thispage ?>" method="post">
<input name="mode" type="hidden" value="bookmark" />
<input type="submit" style="color: green;" value="Bookmark page" />
</form>