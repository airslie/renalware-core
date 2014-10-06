<?php
//----Wed 16 Jun 2010----
foreach ($_POST as $key => $value) {
		$escvalue=$mysqli->real_escape_string($value);
		${$key} = (substr($key,-4)=="date") ? fixDate($escvalue) : $escvalue ;
}
?>