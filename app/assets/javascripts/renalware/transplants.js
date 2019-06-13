$('#rejection-episodes').on('cocoon:after-insert', function(e, insertedItem) {
  initDatepickersIn('#rejection-episodes');
});
