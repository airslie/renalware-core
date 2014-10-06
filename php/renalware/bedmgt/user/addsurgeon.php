<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
?>
<strong>IMPORTANT: (1) Ensure the surgeon is not already in the database and (2) please be sure to use the correct spelling!</strong><br>
The existing list is displayed below -- please check it carefully before adding a new entry.
<?php
include( 'surgeonlist.php' );
?>
<hr>
<form action="run/runaddsurgeon.php" method="post">
<input type="hidden" name="mode" value="add" id="mode" />
<table>
<tr><td class="fldview">First Name</td><td class="data"><input class="form" type="text" size="40" name="surgfirst" ></td></tr>
<tr><td class="fldview">Last Name</td><td class="data"><input class="form" type="text" size="40" name="surglast" ></td></tr>
<tr><td class="fldview">Email</td><td class="data"><input class="form" type="text" size="40" name="surgemail" ></td></tr>
</table>
<input type="submit" name="submit" value="Add new surgeon" id="submit" />