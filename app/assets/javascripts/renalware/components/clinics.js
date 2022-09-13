$(document).ready(function() {
  //
  // When the Clinic drop down changes, we inspect the selected option's data attributes;
  // if the selected option has a different visit_class_name
  // to the currently selected one (most have a blank visit_class_name except for things like
  // HEROIC) then a page refresh is required and we use the refreshUrl to reload the page.
  // This url has the clinic id in the url so will cause the correct fields to be loaded for that
  // clinic.visit_class_name when the page comes back.
  //
  $("#clinic-visit-clinic-dropdown").on("change", function(e) {
    e.preventDefault();
    var selectedOption = $(this).find(':selected');
    var refreshUrl = $(selectedOption).data("refreshUrl");
    var newVisitClassName = $(selectedOption).data("visitClassName");
    // visit_class_name is a hidden input, and will get posted but ignored as it is intentionally
    // not under the correct key in the params. Alternatively we could have made it disabled
    // to avoid it getting posted.
    var currentVisitClassName = $("#visit_class_name").val();

    if ((newVisitClassName || "") != (currentVisitClassName || "")) {
      location.href = refreshUrl;
    }
  });
});
