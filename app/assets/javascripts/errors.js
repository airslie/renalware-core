// For 401 Unathorised responses, for example trying to making a
// js request after a session timeout, reloading the current page
// will redirect the user to the login page.
$(document).ajaxError(function (e, xhr, settings) {
  if (xhr.status == 401) {
    location.reload();
  }
});
