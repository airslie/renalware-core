<?php
//--Tue Jul 24 16:25:06 EDT 2012--
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
if ($row) {
    foreach($row AS $key => $value) 
    {
	${$key} = (strtolower(substr($key,-4))=="date") ? dmyyyy($value) : $value ;
    }
}
