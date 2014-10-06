<?php
//works w/in /renal folder only?
if (isset($_GET['patname']))
{
include('incl/selectpatname.php');
}
else
{
include('incl/enterpatname.php');
}
?>