<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
?>
<p><i>Use this to add information to each diary day (displayed in Admissions and Surgical Diaries) within a given period, e.g. annual leave data.</i><br>
</p><form action="run/runadddaynotes.php" method="post">
<table>
<tr><td class="fldview">Starting Day (d/m/y):</td><td class="data"><input type="text" name="startday" value="" id="startday" size="12"></td></tr>
<tr><td class="fldview">Ending Day (d/m/y):</td><td class="data"><input type="text" name="endday" value="" id="endday" size="12"> OMIT FOR SINGLE-DAY NOTES</td></tr>

<tr><td class="fldview">Day Notes</td><td class="data"><textarea  class="form" name="daynotes" rows="4" cols="60"></textarea></td></tr>
</table>
<input type="submit" value="Continue &rarr;">
</form>
<br>
<p>
<b>Important Notes:</b><br>
<ul>
	<li>If the year is the current year it may be omitted, e.g. enter '21/1' instead of '21/1/2007'</li>
	<li>Two-digit years are acceptable (i.e. '07' or '2007')</li>
	<li>For a single-day event leave the Ending Day field empty</li>
	<li>Day Notes may be up to 255 characters (see below) but please keep to a single line (i.e. no carriage returns)</li>
</ul>
</p>
<i>Example of notes limit (following is 235 characters):</i><br>
<blockquote>
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
</blockquote>