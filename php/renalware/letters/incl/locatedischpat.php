<?php
if (isset($_GET['patname']))
{
include('incl/selectdischpatname.php');
}
if (isset($_GET['hospno']))
{
include('incl/selectdischhospno.php');
}

else
{
echo '<form action="letters/newdischarge.php" method="get">
<input type="hidden" name="stage" value="findpat" />
<b>Name</b>: <input type="text" size="20" name="patname" /> OR 
<b>HospNo</b>: <input type="text" size="20" name="hospno" />&nbsp;
<input type="submit" style="color: green;" value="find patient" /></form>';
}
?>