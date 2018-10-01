$(document).ready(function(){

  var clipboard = new Clipboard('.clipboard-btn');

  clipboard.on('success', function(e) {
    if (e.action != "copy" ) {
      return;
    }

    e.clearSelection();
    var invocation_url = $(e.trigger).parent().closest('tr').data("invocation-url");

    if (invocation_url) {
      $.post(invocation_url);
    }
  });


  // Adapted from https://alligator.io/js/copying-to-clipboard/
  // When a user clicks on a .clipboardable, copy the contents to the clipboard
  // and toggle a 'success' class for shot while to provide visual feedback.
  $(".clipboardable").on('click', function(e) {
    var selection = window.getSelection();
    var range = document.createRange();
    range.selectNodeContents(this);
    selection.removeAllRanges();
    selection.addRange(range);

    console.log(range);

    try {
      document.execCommand('copy');
      selection.removeAllRanges();

      var original = this.textContent;
      this.classList.add('success');

      setTimeout(() => {
        this.classList.remove('success');
      }, 1200);
    } catch(e) {
      // for now do nothing as this is not a crucial error
      // but we could display a js modal error dialog
    }
  });
});
