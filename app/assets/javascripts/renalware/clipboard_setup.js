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
});
