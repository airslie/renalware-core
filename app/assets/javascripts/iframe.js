function resizeIframe(obj) {
  obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
}

$(function() {
  $("iframe.fullsize").each(function() {
    resizeIframe(this);
  })
});