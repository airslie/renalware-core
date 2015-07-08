var Renalware = typeof Renalware == 'undefined' ? {} : Renalware;

Renalware.Letters = (function () {
  var initAuthorsSelect2 = function () {
    $('#letter_author_id').select2();
  };

  return {
    init: function () {
      initAuthorsSelect2();
    }
  };
})();

$(document).ready(Renalware.Letters.init);
