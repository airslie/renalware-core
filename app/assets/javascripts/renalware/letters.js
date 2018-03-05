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
  }

  var bindOnLetterAboutToPrint = function() {
    $(document).on("click", "table.letters .printing-pdf", function(e) {
      var modal = $("#letter-print-modal");
      url = $(this).data("modal-url");
      modal.load(url).foundation('reveal', 'open');
      true;
    });
  }

  var bindOnSalutationChange = function() {

    $("#letter-form").on("click", ".has_salutation", function(e) {
      var salutation = $(this).data('salutation');
      _setSaluation(salutation);
    });

    $("#letter-form").on("change", "select.containing_salutations", function(e) {
      var salutation = $(this).find(':selected').data('salutation');
      _setSaluation(salutation);
    });
  }

  var _setSaluation = function(salutation) {
    if (salutation) {
      $("#letter_salutation").val(salutation);
    }
  }

  var _refreshContactLists = function(url, contact_id, callback) {
    $.getScript(url + "?id=" + contact_id, callback);
  }

  var initNewContact = function(button, callback) {
    if (button.length > 0) {
      var refreshUrl = button.data("source");
      var modalSelector = button.data("modal");
      var modal = new Renalware.Contacts.Modal($(modalSelector), function(contact) {
        _refreshContactLists(refreshUrl, contact.id, function() {
          callback(contact);
        });
      });
      modal.init();

      button.on("click", function(event) {
         event.preventDefault();
         modal.open();
      })
    }
  }

  var initNewContactAsMainRecipient = function() {
    var button = $("a[data-behaviour='add-new-contact-as-main-recipient']");
    initNewContact(button, function(contact) {
      $("#letter_main_recipient_attributes_addressee_id").val(contact.id);
    })
  };

  var initNewContactAsCC = function() {
    var button = $("a[data-behaviour='add-new-contact-as-cc-recipient']");
    initNewContact(button, function(contact) {
      $("#cc-contact-" + contact.id).prop("checked", true);
    })
  };

  var initInsertEventNotesIntoTextEditor = function() {
    $(".insert-data-notes").on("click", function(e) {
      e.preventDefault();
      var notes = $(this).data("notes");
      var targetEditorSelector = $(this).data("target");
      if (notes && targetEditorSelector) {
         var targetInput = $(targetEditorSelector)[0];
         targetInput.editor.insertHTML(notes);
      } else {
        alert("There are no notes to insert");
      }
    });
  }

  return {
    init: function () {
      hideOrShowContactSelector();
      bindOnLetterRecipientTypeChange();
      bindOnSalutationChange();
      initNewContactAsMainRecipient();
      initNewContactAsCC();
      initInsertEventNotesIntoTextEditor();
      bindOnLetterAboutToPrint();
    }
  };
})();

$(document).ready(Renalware.Letters.init);
