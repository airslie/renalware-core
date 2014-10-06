<?php
//----Sun 08 Sep 2013----fix
//created on 2009-05-03.
echo '<td class="opt">'."<a href=\"javascript:medPopup('pat/patient.php?vw=admin&amp;zid=".$row["patzid"]."&amp;menu=hide','View Admin');\">admin</a>&nbsp;&nbsp;";
echo "<a href=\"javascript:medPopup('pat/patient.php?vw=clinsumm&amp;zid=".$row["patzid"]."&amp;menu=hide','View Clin Summ');\">clinsumm</a>&nbsp;&nbsp;";
echo '</td>';
