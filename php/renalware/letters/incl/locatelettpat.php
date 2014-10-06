<?php
if (isset($_GET['patname']))
{
include('incl/selectlettpatname.php');
}
else
{
echo '<form action="letters/newletter.php" method="get">
<input type="hidden" name="stage" value="findpat" />
<input type="text" size="20" name="patname" />
<input type="submit" style="color: green;" value="find lastname[,firstname]" /></form>';
}
?>