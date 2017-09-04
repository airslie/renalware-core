//
// When a .print_pdf link is clicked, use its data-target attribute with
// http://printjs.crabbly.com/ to print the PDF. This, without leaving the current page,
// will bring up the print dialog. IE 11/Edge not supported however.
//
$(document).ready(function() {
  $(".print-pdf").on("click", function(e) {

    // detect IE8 and above, and edge
    if (document.documentMode || /Edge/.test(navigator.userAgent)) {
      // Revert to the default behaviour of showing the PDF in a new tab and the user
      // must print manually.
    } else {
      var url = $(this).data("target");
      if (url) {
        e.preventDefault();
        printJS(url);
      }
    }
  });
});
