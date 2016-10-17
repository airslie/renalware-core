var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Contacts = {
  Modal: function(el, callback) {
    this.el = el,
    this.form = this.el.find("form"),
    this.errorsList = this.form.find("ul.error-messages"),
    this.callback = callback,

    this.init = function() {
      var self = this;
      this.form.on("submit", function(event) { self._onSubmit(event) });
    },

    this.open = function() {
      this.el.foundation("reveal", "open");
      this._clearForm();
      this._clearErrors();
    },

    this._onSubmit = function(event) {
      event.preventDefault();

      var valuesToSubmit = this.form.serialize();
      var self = this;

      this._clearErrors();
      $.ajax({
        type: "POST",
        url: $(this).attr("action"), //sumbits it to the given url of the form
        data: valuesToSubmit,
        dataType: "JSON" // you want a difference between normal and ajax-calls, and json is standard
      }).success(function(json){
        switch (json.status) {
          case "success":
            self._onContactAdded(json.contact);
            break;
          default:
            self._onErrors(json.errors);
        }
      });
    },

    this._onContactAdded = function(contact) {
      this.el.foundation('reveal', 'close');
      this.callback(contact);
    },

    this._clearForm = function() {
      this.form[0].reset();
    },

    this._clearErrors = function() {
      this.errorsList.html("");
    },

    this._onErrors = function(errors) {
      var list = this.errorsList;

      this._clearErrors();
      $.each(errors, function(i) {
        list.append("<li>" + errors[i] + "</li>");
      });
    }
  }
};

$(document).ready(function() {
  var modal = new Renalware.Contacts.Modal($("#add-patient-contact-modal"), function(contact) {
    $("#contacts").load(document.URL + " #contacts");
  });
  modal.init();

  $("a[data-behaviour='add-new-contact']").on("click", function(event) {
     event.preventDefault();
     modal.open();
  })
});