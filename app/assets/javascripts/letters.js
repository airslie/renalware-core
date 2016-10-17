var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Letters = (function() {
  var hideOrShowContactSelector = function() {
    var recipient_type = $("input.recipient-person-role-picker:checked").val();

    if (recipient_type === "contact") {
      $("#contact-selector").show();
    } else {
      $("#contact-selector").hide();
    }
  };

  var bindOnLetterRecipientTypeChange = function() {
    $("#letter-form").change(hideOrShowContactSelector);
  };

  var _reloadMainRecipientContactPicker = function(new_contact_id) {
    $("#contact-selector-input").load(document.URL + " #contact-selector-input", function() {
      $("#letter_main_recipient_attributes_addressee_id").val(new_contact_id);
    });
  };

  var bindOnMainRecipientContactAddedEvent = function() {
    if ($("#letter_main_recipient_attributes_addressee_id").length > 0) {
      $(document).on("contact-added", function(e, data) {
        _reloadMainRecipientContactPicker(data.id)
      });
    }
  };

  return {
    init: function () {
      hideOrShowContactSelector();
      bindOnLetterRecipientTypeChange();
      bindOnMainRecipientContactAddedEvent();
    }
  };
})();

$(document).ready(Renalware.Letters.init);
