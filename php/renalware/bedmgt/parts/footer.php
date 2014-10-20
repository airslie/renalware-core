<div id="footerdiv">	
<?php
if ($mode!='print')
{
$hostname=$_SERVER['HTTP_HOST'];
echo '<a href="http://' . $hostname . htmlentities($_SERVER['REQUEST_URI']) . '&amp;mode=print" title="print mode" >email/print screen</a> (new window)<br><br>';
}
include 'versionstamp.php';
?>
</div>
</body>
</html>