$(document).on('change', 'input[name=action_type]', function(e) {
  $('.action-fields').removeClass('active')
    .filter('[data-action_type=' + e.target.value +']')
    .addClass('active');

  reflowEpicEditor();
});
