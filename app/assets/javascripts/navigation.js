$(document).ready(function(){

  $(window).scroll(function() {
    var scroll = $(window).scrollTop();
    if (scroll > 50){
      $(".remove-name").removeClass("patient-name");
    } else {
      $(".remove-name").addClass("patient-name");
    }
  });


});