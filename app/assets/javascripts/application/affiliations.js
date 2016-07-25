$(document).on('ready', function() {

  var $affiliations = $('#affiliations');

  // Users must input complete institution/relationship pairs.
  $affiliations.on('change', 'select', function() {
    var select_pair = $(this).closest('.nested-fields').find('select');
    var at_least_one_selected = _.reduce(select_pair, function(m, n) {
      return m + $(n).val().length;
    }, 0);
    select_pair.prop('required', at_least_one_selected);
  });

  // Greyed-out placeholder text
  $affiliations.on('change', 'select', function() {
    $(this).toggleClass("empty", $.inArray($(this).val(), ['', null]) >= 0);
  })

  function affiliation_added() {
    // Autocomplete select using select2
    $('#affiliations select.institution').select2({
      theme: 'bootstrap',
      placeholder: 'Institution'
    }).on("select2:close", function (e) {
      // focus the next element when the select2 is closed
      $('.affiliation-type').focus();
    });
    height_changed();
  }

  $affiliations.on('cocoon:after-insert', function(e, insertedItem) {
    affiliation_added();
  }).trigger('cocoon:after-insert');

  // Autocomplete filter by institution
  $('#signatures select.institution').select2({
    theme: 'bootstrap',
    placeholder: 'Filter by institution'
  });

  // Open autocomplete on keypress
  $('body').on('keypress', '.select2-container--focus', function(e) {
    if (e.which >= 32) {
      var $select = jQuery(this).prev();
      $select.select2('open');

      var $search = $select.data('select2').dropdown.$search || $select.data('select2').selection.$search;
      $search.val(String.fromCharCode(e.which));
      // Timeout seems to be required for Blink
      setTimeout(function() {
        $search.get(0).setSelectionRange(1,1);
        $search.trigger('keyup');
      },0 );
    }
  });
});