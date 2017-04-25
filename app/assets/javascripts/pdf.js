//
// When a .print_pdf link is clicked, use its data-target attribute with
// http://printjs.crabbly.com/ to print the PDF. This, without leaving the current page,
// will bring up the print dialog. IE 11/Edge not supported however.
//
$(document).ready(function() {
  $(".print-pdf").on("click", function(e) {
    // No IE/Edge supports smil - for these we revert to the default behaviour of showing
    // the PDF in a new tab and the user must print manually.
    if (Modernizr.smil) {
      var url = $(this).data("target");
      if (url) {
        e.preventDefault();
        printJS(url);
      }
    }
  });
});
