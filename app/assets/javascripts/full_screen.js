$(document).on("click", ".trigger-full-screen", function(e) {
  e.preventDefault();
  $(".full-screen-container")[0].webkitRequestFullscreen();
});
