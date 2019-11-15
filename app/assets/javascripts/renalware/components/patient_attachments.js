$(document).ready(function(){
  $('#patients_attachment_attachment_type_id').change(function(e) {
    // The selected option has a data-store-file-externally attribute that we
    // will use to toggle visibility of the file upload and external_location fields.
    var storeFileExternally = $(e.currentTarget).find("option:selected").data("store-file-externally");
    //if (storeFileExternally == true) {
      // $('.patients_attachment_external_location').show();
      // $('.patients_attachment_file').hide();
      $('#patients_attachment_external_location').prop("disabled", !storeFileExternally);
      $('#patients_attachment_file').prop("disabled", storeFileExternally);
    // } else {
    //   $('.patients_attachment_external_location').prop("disabled", false);
    //   $('.patients_attachment_file').prop("disabled", true);
    // }
  });
});
