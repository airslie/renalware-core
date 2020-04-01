$(document).on("ajax:error", function(event) {
  var xhr = event.detail[2];
  switch(xhr.status) {
    case 500:
      alert("Your request has unexpectedly failed (" + xhr.statusText + "). Please try again.");
  }
});
