<?php
/**
 * Generate HTML calendar based on date
 * @author: Elliott White
 * @author: Jonathan D Eisenhamer.
 * @link: http://www.quepublishing.com/articles/article.asp?p=664657&seqNum=7&rl=1
 * @since: December 1, 2006.
 */
 //excellent code adapted by PNA 2 Mar 07 with dynamic links
 
if( function_exists( 'date_default_timezone_set' ) )
{
	// Set the default timezone to US/Eastern
	date_default_timezone_set( 'Europe/London' );
}

// Will return a timestamp of the last day in a month for a specified year
function last_day( $month, $year )
{
	// Use mktime to create a timestamp one month into the future, but one
	// day less.  Also make the time for almost midnight, so it can be
	// used as an 'end of month' boundary
	return mktime( 23, 59, 59, $month + 1, 0, $year );
}

// This function will print an HTML Calendar, given a month and year
//add thisday to hilight Sun Aug 26 12:58:17 CEST 2007
function print_calendar( $month, $year, $weekdaytostart = 0, $thisday )
{
	// There are things we need to know about this month such as the last day:
	$last = idate( 'd', last_day( $month, $year ) );

	// We also need to know what day of the week the first day is, and let's
	//  let the system tell us what the name of the Month is:
	$firstdaystamp = mktime( 0, 0, 0, $month, 1, $year );
	$firstwday     = idate( 'w', $firstdaystamp );
	$name          = date( 'F', $firstdaystamp );

	// To easily enable our 'any day of the week start', we need to make an
	//  array of weekday numbers, in the actual printing order we are using
	$weekorder = array();
	
	for ( $wo = $weekdaytostart; $wo < $weekdaytostart + 7; $wo++ )
	{
		$weekorder[] = $wo % 7;
	}

	// Now, begin our HTML table
	echo "<table><tr><th colspan=\"7\">{$name} {$year}</th></tr>\n";

	// Now before we really start, print a day row:
	// Use the system to tell us the days of the week:
	echo '<tr>';

	// Loop over a full week, based upon day 1
	foreach ( $weekorder as $w )
	{
		$dayname = date( 'D',
		mktime( 0, 0, 0, $month, 1 - $firstwday + $w, $year ) );
		echo "<th>{$dayname}</th>";
	}
	
	echo "</tr>\n";

	// Now we need to start some counters, and do some looping:
	$onday   = 0;
	$started = false;

	// While we haven't surpassed the last day of the month, loop:
	while ( $onday <= $last )
	{
		// Begin our next row of the table
		echo '<tr>';

		// Now loop 0 through 6, for the days of the week, but in the order
		//  we are actually going, use mod to make this work
		foreach ( $weekorder as $d )
		{
			// If we haven't started yet:
			if ( !( $started ) )
			{
				// Does today equal the first weekday we should start on?
				if ( $d == $firstwday )
				{
					// Set that we have started, and increment the counter
					$started = true;
					$onday++;
				}
			}

			// Now if the day is zero or greater than the last day make a
			//  blank table cell.
			if ( ( $onday == 0 ) || ( $onday > $last ) )
			{
				echo '<td>*</td>';
			}
			else
			{
				// Otherwise, echo out a day & Increment the counter
			//	echo "<td>{$onday}</td>";
			//make unixymd
			$calymd=$year . '-'. str_pad($month, 2, '0', STR_PAD_LEFT) . '-'. str_pad($onday, 2, '0', STR_PAD_LEFT);
			//set date link Fri Mar  2 10:37:26 CET 2007
			$link="index.php?vw=glance&amp;scr=dayview&ymd=$calymd";
			//let's highlight currday Sun Aug 26 12:43:46 CEST 2007
			$showday="<td><a href=\"$link\">{$onday}</a></td>";
			if ($calymd==$thisday) {
				$showday="<td><span class=\"thisday\">{$onday}</span></td>";
			}
				echo $showday;
				$onday++;
			}
		}

		// End this table row:
		echo "</tr>\n";
	}

	// Now end the table:
	echo '</table>';
}

// ========================================================
// = Demo showing calendar for all months of current year =
// ========================================================

// Output some formatting directives:
// Create an entire year calendar for 2007 with Monday as the first day:
//foreach( range( 1, 12 ) as $m )
//for next 3 months:
//based on selected YMD as GET
$ymdx=explode("-",$searchday);
$thisday=$ymdx[2];
$thismonth=$ymdx[1];
$prevmonth=$thismonth-1;
$nextmonth=$thismonth+1;
$selyear=$ymdx[0];
$prevmonthY=$selyear; //def
$thismonthY=$selyear;
$nextmonthY=$selyear;
//correct for Nov, Dec
if ( $thismonth==12 )
	{
	$nextmonth=1;
	$nextmonthY=$thismonthY+1;
	}
//correct for Jan
if ( $thismonth==1 )
	{
	$prevmonth=12;
	$prevmonthY=$thismonthY-1;
	}
$nextmonth01=$nextmonthY .'-'.str_pad($nextmonth, 2, "0", STR_PAD_LEFT) . '-01';
$prevmonth01=$prevmonthY .'-'.str_pad($prevmonth, 2, "0", STR_PAD_LEFT) . '-01';
//print 1, 2, 3
print_calendar( $prevmonth, $prevmonthY, 0, $searchday );
?>
<br><div class="thismonth">
<a class="small" href="index.php?vw=glance&amp;scr=dayview&amp;ymd=<?php echo $prevmonth01 ?>">&lt;&lt;prev month</a>
<?php
//add searchday for hilight currday
print_calendar( $thismonth, $thismonthY, 0, $searchday );
?>
<a class="small" href="index.php?vw=glance&amp;scr=dayview&amp;ymd=<?php echo $nextmonth01 ?>">next month&gt;&gt;</a>
</div><br>
<?php
print_calendar( $nextmonth, $nextmonthY, 0, $searchday );
?>
