$(document).ready(function(){

  $(window).scroll(function() {
    var $scroll = $(window).scrollTop();
    if ($scroll > 50){
      $(".remove-name").removeClass("patient-name");
    } else {
      $(".remove-name").addClass("patient-name");
    }
  });

  // Auto select the active tab based on the url, unless the subnav has the no-js-selection class
  $(".sub-nav:not('.no-js-selection') dd").each(function(){
    var $href = $(this).find("a").attr('href');
    if ($href === window.location.pathname) {
      $(this).addClass('active');
    }
  });

  $(document).foundation({
    "magellan-expedition": {
      destination_threshold: 30,
      fixed_top: 49
    }
  });
});
