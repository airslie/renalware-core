<?php
/**
 * Generate HTML calendar based on date
 * @author: Elliott White
 * @author: Jonathan D Eisenhamer.
 * @link: http://www.quepublishing.com/articles/article.asp?p=664657&seqNum=7&rl=1
 * @since: December 1, 2006.
 */
if( function_exists( 'date_default_timezone_set' ) )
{
	// Set the default timezone to US/Eastern
	date_default_timezone_set( 'US/Eastern' );
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
function print_calendar( $month, $year, $weekdaytostart = 0 )
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
			$ymd=$year . '-'. str_pad($month, 2, '0', STR_PAD_LEFT) . '-'. str_pad($onday, 2, '0', STR_PAD_LEFT);
			$link="index.php?vw=glance&amp;scr=dayview&ymd=$ymd";
				echo "<td><a href=\"$link\">{$onday}</a></td>";
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
$monthstart=date("m");
$desirednomonths=3;
$monthend=$monthstart + $desirednomonths -1;
//nb fix for NOV, DEC!
//foreach( range( 1, 12 ) as $m )
foreach( range( $monthstart, $monthend ) as $m )
{
	print_calendar( $m, date( 'Y' ), 0 );
	echo '<br>';
}
//print this month only
//	print_calendar( $thismonth, date( 'Y' ), 0 );

?>