<?php
$fields = "
	lowAccessClinic,
	lowFirstseendate,
	lowDialPlan,
	lowDialPlandate,
	lowPredictedESRFdate,
	lowReferralCRE,
	lowReferredBy,
	lowEducationStatus,
	lowReferralEGFR,
	lowEducationType,
	lowAttendeddate,
	lowDVD1,
	lowDVD2,
	lowTxReferralflag,
	lowTxReferraldate,
	lowHomeHDflag,
	lowSelfcareflag,
	alertflag,
	lowAccessnotes";
$sql= "SELECT $fields FROM renaldata WHERE renalzid=$zid LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
?>