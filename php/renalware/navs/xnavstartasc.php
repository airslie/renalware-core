<?php
if (!isset ($_GET['show'])) {
	$display = 1; // Change to $NUMROWS if DESCENDING order is required
} else {
	$display = $_GET['show'];
}
// Return results from START to LIMIT
$start = (($display * $limit) - $limit);
?>