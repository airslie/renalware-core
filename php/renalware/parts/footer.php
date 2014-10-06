<?php
//----Thu 06 Dec 2012----
// echo '<div id="footer">';
// if ($user) {
//     echo "<p>logged in as <b>$user</b> since ".date('Y m d H:i:s', $_SESSION['starttime'])."<i>($mins mins)</i></p>";
// }
ob_end_flush();
echo '<p id="printfooter">
Printed by <b>'.$user.'</b> with Renalware v.'.$versionno.' at '.date('Y m d H:i:s', time()).'</p><!-- /printfooter -->
</div> <!-- /content -->
</body>
</html>';
