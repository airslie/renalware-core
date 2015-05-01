$(document).ready(function(){

  $(window).scroll(function() {
    var $scroll = $(window).scrollTop();
    if ($scroll > 50){
      $(".remove-name").removeClass("patient-name");
    } else {
      $(".remove-name").addClass("patient-name");
    }
  });


 
  $("dd").each(function(){
    var $href = $(this).find('a').attr('href');
    if ($href === window.location.pathname) {
      $(this).addClass('active');
    }
  });


});