$(document).on('change', 'input[name=action_type]', function(e) {
  $('.action-fields').removeClass('active')
    .filter('[data-action_type=' + e.target.value +']')
    .addClass('active');

  $('[id^=action_page_enable_').attr('value', 'false');
  $('#action_page_enable_' + e.target.value).attr('value', 'true');

  reflowEpicEditor();
});

$(document).on('click', '#individual-targets #add', function(e) {
  e.preventDefault();

  var add = $(this).closest('li');
  var input = add.find('input');
  var handle = input.val().replace(/^@+/, '');

  var li = $('<li>');
  li.append($('<a>').attr({ href: 'https://twitter.com/'+handle, target: '_new' }).text('@'+handle));
  li.append(
    $('<input>').attr({
      name: 'action_page[tweet_attributes][tweet_targets_attributes]['+add.siblings('li').length+'][twitter_id]',
      value: handle,
      type: 'hidden'
    })
  );

  add.before(li);

  input.val('').focus();
});
