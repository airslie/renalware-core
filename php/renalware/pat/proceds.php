<?php
//----Mon 27 Aug 2012----
//set DB
$mysqli->select_db("bedmgt");
if ($_SESSION['bedmgrflag']=='1') {
echo "<p><a href=\"bedmgt/index.php?vw=proced&amp;scr=requestsurgcase&amp;zid=$zid\">Request Proced for this patient</a></p>";
}
echo "<h3>Pending</h3>";
$where="WHERE pzid=$zid AND status='Req'";
include "../bedmgt/pat/zidlist_incl.php";
echo "<h3>Scheduled</h3>";
$where="WHERE pzid=$zid AND status='Sched'";
include( "../bedmgt/pat/zidlist_incl.php" );
echo "<h3>Archived</h3>";
$where="WHERE pzid=$zid AND status='Arch'";
include( "../bedmgt/pat/zidlist_incl.php" );
echo "<h3>Cancelled</h3>";
$where="WHERE pzid=$zid AND status='Canc'";
include( "../bedmgt/pat/zidlist_incl.php" );
