<?php
foreach($row AS $key => $value)
	{ //parse $rows
	${$key} = $value;
	if (strtolower(substr($key,-4))=="date")
		{
		${$key} = dmyyyy($value);
		}
	}
?>