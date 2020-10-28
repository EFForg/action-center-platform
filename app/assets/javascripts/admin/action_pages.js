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
  $('#filter_action_pages #date_range').on('focus', function(){
    $(this).daterangepicker({
      locale: { format: 'YYYY-MM-DD' }
    });
  });
  $('#filter_action_pages #date_range').on('apply.daterangepicker', filterActionPages);
})();

$('.action_page_setup').on('change', 'input[name=action_type]', function(e) {
  $('.action-fields').removeClass('active')
    .filter('[data-action_type=' + e.target.value +']')
    .addClass('active');

  $('[id^=action_page_enable_').attr('value', 'false');
  $('#action_page_enable_' + e.target.value).attr('value', 'true');

  reflowEpicEditor();
});

$('.action_page_setup').on('change', 'input[name=action_type]', function(e) {
  if (e.target.value == 'redirect')
    $('#nav li[data-hide-for-redirect]').slideUp(100);
  else
    $('#nav li[data-hide-for-redirect]').slideDown();
});

$(function() {
  $('.action_page_setup').find('input[name=action_type]:checked').trigger('change');
});

$('.action_page_setup').on('click', '#nav a[href=#save]', function(e) {
  e.preventDefault();
  $('form', '#content').first().submit();
});

$('.action_page_setup').on('change', '#action_page_petition_attributes_enable_affiliations', function() {
  $('#affiliations-enabled').toggle($(this).prop('checked'));
});

$('.action_page_setup').on('change', '#institutions_reset', function() {
  $('#add-institutions').toggle($(this).prop('checked'));
});

$('#affiliations-enabled').on('keyup paste', '#affiliation-types input', function() {
  $(this).parent().next('.form-item').show();
});

$('.action_pages-edit_partners').on('select2:select', "#action_page_partner_ids", function(e) {
  var id = '#partner-' + e.params.data.id;
  if ($(id).length > 0 ) {
    // Re-enable mailing field
    $(id + ' :input').prop('disabled', false);
    $(id).next(':input').prop('disabled', false);
    $(id).show();
  }
});

$('.action_pages-edit_partners').on('select2:unselect', "#action_page_partner_ids", function(e) {
  var id = '#partner-' + e.params.data.id;
  $(id + ' :input').prop('disabled', true);
  $(id).next(':input').prop('disabled', true);
  $(id).hide();
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

$('.action_page_setup').on('change', '[type=checkbox][name*=target_]', function(e) {
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
});

$('.action_pages-index').on('click', '.table .page-actions', function() {
  $('.page-actions.open').removeClass('open');
  $(this).addClass('open');
});

$('.action_pages-index').on('click', function(e) {
  if (!$(e.target).closest('.page-actions').length)
    $('.page-actions.open').removeClass('open');
});

$('.action_pages-status').on('change', ':radio', function() {
  var is_victory = $('#action_page_status_victory').is(':checked');
  $("#victory-message").toggle(is_victory);
});
