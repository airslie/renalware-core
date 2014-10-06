<?php
//--Fri Mar  8 11:30:59 EST 2013--
//end content container, push, /wrap
echo '</div>
    <div id="push"></div>
</div>';
    //footer here
    echo '<div id="footer">
      <div class="container">
        <p>logged in as <b>'.$user.'</b> since '.date('Y m d H:i:s', $_SESSION['starttime']).' <i>('.$mins.' mins)</i></p>
      </div>
    </div>';
?>
<!-- cf http://stackoverflow.com/questions/7643308/how-to-automatically-close-alerts-using-twitter-bootstrap -->
<script>
window.setTimeout(function() {
    $(".alert-fade").fadeTo(500, 0).slideUp(500, function(){
        $(this).remove(); 
    });
}, 5000);
</script>
</body>
</html>
