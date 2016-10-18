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

  var _reloadCCsList = function(new_contact_id) {
    $("#letter-ccs").load(document.URL + " #letter-ccs");
  };

  var initNewContactAsMainRecipient = function() {
    var trigger = $("a[data-behaviour='add-new-contact-as-main-recipient']");

    if (trigger.length > 0) {
      var modal = new Renalware.Contacts.Modal($("#add-patient-contact-modal"), function(contact) {
        _reloadMainRecipientContactPicker(contact.id)
        _reloadCCsList()
      });
      modal.init();

      trigger.on("click", function(event) {
         event.preventDefault();
         modal.open();
      })
    }
  };

  return {
    init: function () {
      hideOrShowContactSelector();
      bindOnLetterRecipientTypeChange();
      initNewContactAsMainRecipient();
    }
  };
})();

$(document).ready(Renalware.Letters.init);
