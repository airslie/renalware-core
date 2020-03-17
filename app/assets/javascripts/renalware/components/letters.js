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

  var bindOnLetterAboutToBatchPrint = function() {
    $(document).on("click", ".print-batch-letter", function(e) {
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

  // var initInsertEventNotesIntoTextEditor = function() {
  //   $(".insert-data-notes").on("click", function(e) {
  //     e.preventDefault();
  //     var notes = $(this).data("notes");
  //     var targetEditorSelector = $(this).data("target");
  //     if (notes && targetEditorSelector) {
  //        var targetInput = $(targetEditorSelector)[0];
  //        targetInput.editor.insertHTML(notes);
  //     } else {
  //       alert("There are no notes to insert");
  //     }
  //   });
  // };

  var pollBatchStatus = function(url) {
    var POLL_INTERVAL = 2000; // ms
    var batch = {};

    // Check the current status of the TaskStatus object.
    var updateStatus = function() {
      $.ajax({
        method: 'GET',
        url: url,
        contentType: 'json'
      }).fail(function(e, x, a) {
        // Possible network glitch or perhaps a re-deploy causing the site to be down momentarily.
        // Anyway, not enough for us to give up polling.
        // TODO: examine the response code to see if we should in fact give up and show an
        // appropriate message.
        setTimeout(updateStatus, POLL_INTERVAL);
      }).done(function(batch) {
        // Done!
        $(".modal .percent_complete").html(batch.percent_complete + "%");
        if(batch.status == 'awaiting_printing') {
          $(".batch_results_container .preparing").hide();
          $(".batch_results_container .generated-batch-print-pdf-container").show();
        }
        // Not done!
        else {
          // Could update a progress/100% tracker here
          // Ask again in POLL_INTERVAL ms.
          setTimeout(updateStatus, POLL_INTERVAL);
        }
      });
    };
    setTimeout(updateStatus, POLL_INTERVAL);
  };

  return {
    init: function () {
      hideOrShowContactSelector();
      bindOnLetterRecipientTypeChange();
      bindOnSalutationChange();
      initNewContactAsMainRecipient();
      initNewContactAsCC();
      //initInsertEventNotesIntoTextEditor();
      bindOnLetterAboutToBatchPrint();
      bindOnLetterAboutToPrint();
    },
    pollBatchStatus: pollBatchStatus
  };
}());

$(document).ready(Renalware.Letters.init);
