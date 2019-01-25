$(document).ready(function() {
  // When the Clinic drop down changes, if the selected option indicates a page refresh is required,
  // append the clinic id to the page href and issue a refresh. This lets the page reload with the
  // correct fields displayed for that clinic visit type (e.g. HEROIC)
  $("#clinic-visit-clinic-dropdown").on("change", function(e) {
    e.preventDefault();
    var url = $(this).find(':selected').data("refreshUrl");
    if (url && location.href != url) {
      location.href = url;
    }
  });
});
