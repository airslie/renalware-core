var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

function ContactModal(modalSelector) {
  this.el = $(modalSelector),
  this.form = this.el.find("form"),
  this.errorsList = this.form.find("ul.error-messages"),

  this.init = function() {
    var self = this;
    this.form.on("submit", function(event) { self._onSubmit(event) });
  },

  this.open = function() {
    this.el.foundation("reveal", "open");
  }

  this._onSubmit = function(event) {
    event.preventDefault();

    console.log(this);

    var valuesToSubmit = this.form.serialize();
    var self = this;

    $.ajax({
      type: "POST",
      url: $(this).attr("action"), //sumbits it to the given url of the form
      data: valuesToSubmit,
      dataType: "JSON" // you want a difference between normal and ajax-calls, and json is standard
    }).success(function(json){
      console.log(json);
      if (json.status == "success") {
        self._onContactAdded(json.contact);
      } else {
        self._onErrors(json.errors);
      }
    });
  },

  this._onContactAdded = function(contact) {
    this.el.foundation('reveal', 'close');
    $("#contacts").load(document.URL + " #contacts");
  },

  this._onErrors = function(errors) {
    var list = this.errorsList;

    list.html("");
    $.each(errors, function(i) {
      list.append("<li>" + errors[i] + "</li>");
    });
  }
}

$(document).ready(function() {
  var form = new ContactModal("#add-patient-contact-modal");
  form.init();

  $("a[data-behaviour='add-new-contact']").on("click", function(event) {
     event.preventDefault();
     form.open();
  })
});
