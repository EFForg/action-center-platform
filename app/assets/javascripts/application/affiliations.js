$(document).on('ready', function() {

  var $affiliations = $('#affiliations');

  // Users signing the petition must input complete institution/relationship pairs.
  $affiliations.on('change', 'select', function() {
    var select_pair = $(this).closest('.nested-fields').find('select');
    var at_least_one_selected = _.reduce(select_pair, function(m, n) {
      return m + $(n).val().length;
    }, 0);
    select_pair.prop('required', at_least_one_selected);
  });

  // Greyed-out placeholder text for selects
  $affiliations.on('change', 'select', function() {
    $(this).toggleClass("empty", $.inArray($(this).val(), ['', null]) >= 0);
  })

  var category = $affiliations.find('#signature_affiliations_attributes_0_institution_id')
                              .children('option:first').text();
  var select2_options = {
    theme: 'bootstrap',
    placeholder: category
  }

  // If institutions are passed as json, load them as paginated data
  // in select2 menus.
  var institutions = $("select[data-institutions]").data("institutions");
  if (typeof institutions !== 'undefined') {
    $.extend(select2_options, {
      dataAdapter: $.fn.select2.amd.require('select2/data/pagedAdapter'),
      jsonData: institutions,
      jsonMap: {id: "id", text: "name"},
      ajax: {}
    })
  }

  $affiliations.on('cocoon:after-insert', function(e, insertedItem) {
    affiliation_added();
  }).trigger('cocoon:after-insert');

  function affiliation_added() {
    // Autocomplete institution when signing petition.
    $('#affiliations select.institution').select2(select2_options)
      .on("select2:close", function (e) {
        // Focus the next element when the select2 is closed.
        $('.affiliation-type').focus();
      });
    height_changed();
  }

  // Autocomplete institution when filtering signatures.
  $('#signatures select.institution').select2(
    $.extend({}, select2_options, {
      placeholder: 'Filter by ' + category
    })
  )
});
