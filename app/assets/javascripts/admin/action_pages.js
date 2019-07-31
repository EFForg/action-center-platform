(function() {
  var filterActionPages = function(e) {
    if (e.type == "submit")
      e.preventDefault();

    var form = $(e.target).closest("form")[0];

    // timeout required for this to behave correctly during a form reset
    setTimeout(function() {
      $.get(form.action + '?' + $(form).serialize(), function(resp) {
        $('#content .table').replaceWith(resp);
      });
    }, 1);
  };

  $('#filter_action_pages').on('submit', filterActionPages);
  $('#filter_action_pages').on('reset', filterActionPages);
  $('#filter_action_pages select').on('change', filterActionPages);
})();

$('.action_pages-edit, .action_pages-new').on('change', 'input[name=action_type]', function(e) {
  $('.action-fields').removeClass('active')
    .filter('[data-action_type=' + e.target.value +']')
    .addClass('active');

  $('[id^=action_page_enable_').attr('value', 'false');
  $('#action_page_enable_' + e.target.value).attr('value', 'true');

  reflowEpicEditor();
});

$('.action_pages-edit, .action_pages-new').on('change', 'input[name=action_type]', function(e) {
  if (e.target.value == 'redirect')
    $('#nav li[data-hide-for-redirect]').slideUp(100);
  else
    $('#nav li[data-hide-for-redirect]').slideDown();
});

$(function() {
  $('.action_pages-edit, .action_pages-new').find('input[name=action_type]:checked').trigger('change');
});

$('.action_pages-edit, .action_pages-new').on('click', '#nav a[href=#save]', function(e) {
  e.preventDefault();
  $('form', '#content').first().submit();
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

$('.action_pages-edit, .action_pages-new').on('change', '[type=checkbox][name*=target_]', function(e) {
  if (e.target.name.match(/target_house|target_senate/) && e.target.checked) {
    $(this).closest('fieldset').find('[name*=target_specific_legislators]').prop('checked', false);
    $(this).closest('fieldset').find('.select2').slideUp(40);
  } else if (e.target.checked) {
    $(this).closest('fieldset').find('[name*=target_house],[name*=target_senate]').prop('checked', false);
    $(this).closest('fieldset').find('.select2').slideDown(40, function() {
      $(this).siblings('select').focus();
    });
  }
});

$('#action-page-preview').on('click', function(e) {
  e.preventDefault();
  var form = $('.edit_action_page');
  $.ajax({
    method: 'PATCH',
    url: $(this).attr('href'),
    data: form.serialize(),
    dataType: 'html',
    success: function(data) {
      window.open().document.write(data);
    }
  });

$('.action_pages-index .table .page-actions').on('click', function(){
  $(this).children('ul').toggle();
});
