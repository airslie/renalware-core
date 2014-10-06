<?php
//Wed Sep 10 16:32:21 BST 2008 added HDF and sent to new hdsessiondata w/o profile data
$schedule = $currsched . '-' . $currslot;
$weightchange = $wt_post-$wt_pre;
include "$rwarepath/renal/hd/run/run_insertsessiondata.php";
//----Mon 25 Feb 2013----DEPR bp validation