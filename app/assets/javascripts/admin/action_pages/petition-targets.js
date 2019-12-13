$(document).on('ready', function() {
  $('#institutions-index').on('click', 'button[type=reset]', function(e) {
    e.preventDefault();
    var $form = $(this).parents('form');
    $form.find('input').val('');
    $form.find('select').val('').trigger('change');
    $form.submit();
  });
  $('#import-institutions-form').on('change', '#institutions_category', function(e) {
    if($(this).val() == '') {
      $('#new-category').show();
    } else {
      $('#new-category input').val('');
      $('#new-category').hide();
    }
  });
});

