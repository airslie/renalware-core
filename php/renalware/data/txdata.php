<?php
//Sun Dec 20 12:50:47 JST 2009
$fields = "
txWaitListEntryDate,
txWaitListModifDate,
txWaitListNotes,
txWaitListStatus,
txAbsHighest,
txAbsHighestDate,
txAbsLatest,
txAbsLatestDate,
txBloodGroup,
txHLAType,
txHLATypeDate,
txNoGrafts,
txSensStatus,
txTransplType,
txWaitListContact
";
$sql= "SELECT $fields FROM renaldata WHERE renalzid=$zid LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
?>