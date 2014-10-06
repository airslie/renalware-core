<?php
//needed for screens
//cosmetics
//paging stuff
$paging = ceil ($numtotal / $limit);
// Display the navigation
if ($display > 1) {	
	$previous = $display - 1;	
?>
<a style="color: green; font-size: .9em; font-weight: normal; padding: 2px;" href="<?php echo  $_SERVER['PHP_SELF']; ?>?<?php echo  $q; ?>show=1"><< First</a> &nbsp;  
<a style="color: green; font-size: .9em; font-weight: normal; padding: 2px;" href="<?php echo  $_SERVER['PHP_SELF'] ?>?<?php echo  $q; ?>show=<?php echo  $previous; ?>">< Previous</a> &nbsp; 
<?php
}
if ($numtotal != $limit) {	
	if ($paging > $scroll) { // REMOVE THIS TO GET RID OF THE SCROLL FEATURE		
		$first = $_GET['show']; // REMOVE THIS TO GET RID OF THE SCROLL FEATURE	
		$last = ($scroll - 1) + $_GET['show']; // REMOVE THIS TO GET RID OF THE SCROLL FEATURE	
	} else { // REMOVE THIS TO GET RID OF THE SCROLL FEATURE	
		$first = 1;	
		$last = $paging;
	} // REMOVE THIS TO GET RID OF THE SCROLL FEATURE
		if ($last > $paging ) {		
			$first = $paging - ($scroll - 1);		
			$last = $paging;		
	}
	for ($i = $first;$i <= $last;$i++){	
		if ($display == $i) {		
?>
&nbsp; <span style="color: red; background: yellow; font-weight: bold; font-size: .9em; padding: 2px;">page <?php echo $i ?></span> &nbsp;
<?php	
		} else {
?>
&nbsp;  <a style="color: green; font-size: .9em; font-weight: normal; padding: 2px;" href="<?php echo  $_SERVER['PHP_SELF']; ?>?<?php echo  $q; ?>show=<?php echo  $i; ?>">p<?php echo  $i; ?></a> &nbsp; 
<?php
		}
	}
}
if ($display < $paging) {
	$next = $display + 1;
?>
&nbsp; <a style="color: green; font-size: .9em; font-weight: normal; padding: 2px;" href="<?php echo  $_SERVER['PHP_SELF']; ?>?<?php echo  $q; ?>show=<?php echo  $next; ?>">Next ></a> &nbsp; 
<a style="color: green; font-size: .9em; font-weight: normal; padding: 2px;" href="<?php echo  $_SERVER['PHP_SELF']; ?>?<?php echo  $q; ?>show=<?php echo  $paging; ?>">Last >></a>
<?php
}
//
echo "<br>";
?>