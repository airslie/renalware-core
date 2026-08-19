$(document).ready(function(){
  // Auto select the active tab based on the url, unless the subnav has the no-js-selection class
  $(".sub-nav:not('.no-js-selection') dd").each(function(){
    var $href = $(this).find("a").attr('href');
    if ($href === window.location.pathname) {
      $(this).addClass('active');
    }
  });
});
