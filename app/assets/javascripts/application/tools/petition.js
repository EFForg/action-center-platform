$(document).on('ready', function() {
  height_changed();
  _.templateSettings.interpolate = /{{([\s\S]+?)}}/g;

  $('form.petition-tool').on('submit', function(ev) {
    var form = $(ev.currentTarget);

    // There are two types of errors: inline (.has-error) and not (.alert-danger)
    form.find('.has-error').removeClass('has-error');
    form.find('.alert-danger').remove();
    form.find('.error').remove();
    form.find(".progress-striped").show();
    form.find("input[type=submit]").hide();
    var petition_id = $('[name="petition-id"]', form).val();
    // var url = 'http://eff-call-tool.herokuapp.com/eff_test';
    var url = '/tools/petition';
    $.ajax({
      url: url,
      data: form.serializeObject(),
      type: 'POST',
      success: function(data) {
        if (data.success) {
          $('#petition-tool').removeClass('unsigned').addClass('signed');
          height_changed();
          incrementPetitionCount();
        }
        else if (data.errors) {
          var errors = JSON.parse(data.errors);
          for (var field_name in errors) {
            var field = form.find("#signature_" + field_name);
            var error = errors[field_name];
            if (field.length) {
              error = $('<div class="error help-block small">').text(error);
              error.prepend(field.attr('placeholder') + ': ');
              field.closest('fieldset').addClass('has-error');
              error.insertAfter(field);
              form.find(".progress-striped").hide;
              form.find("input[type=submit]").show();
            }
            else {
              show_error(error, form);
            }
          }
        }
      },
      error: function() {
        show_error("Something seems to have gone wrong. Please try again.", form);
      }
    });
    return false;
  });

  function show_error(error, form) {
    form.find(".progress-striped").hide();
    form.find("input[type=submit]").show();
    form.find('.alert-danger').remove();
    form.prepend($('<div class="small alert alert-danger help-block">').text(error));
  }

  function incrementPetitionCount() {
    var n = getPetitionCount() + 1;
    setPetitionCountValue(n);
  }

  // give it an integer and it prints it all pretty on the screen
  function setPetitionCountValue(n) {
    var countEle = petitionCountElement();
    countEle.text(applyPrettyFormatting(n));

    function applyPrettyFormatting() {
      return n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
  }

  function getPetitionCount() {
    var countEle = petitionCountElement();
    return parseInt(countEle.text().replace(",",""));
  }

  function petitionCountElement() {
    return $('#petition-tool .count b');
  }

  var getSignaturesInterval = 2000;
  var previousSignatures = {};
  var getSignatures = function(){
    $.ajax({
      url: '/petition/' + petition_id + '/recent_signatures',
      success: function(data){
        var signatures_total = data.signatures_total;
        setPetitionCountValue(signatures_total);

        var progress_total = $('.signatures-bar').attr('aria-valuemax');
        $(".signatures-bar").attr('aria-valuenow', signatures_total).css({width: signatures_total/progress_total*100 + '%'});
        var signatures = data.signatories;
        var individual_signature_template = $('#individual_signature').html();
        var signatures_html = _.map(signatures, function(signature){
          return _.template(individual_signature_template)({
            name: (signature.first_name ? signature.first_name + " " + signature.last_name : "Anonymous"),
            location: signature.location,
            time_ago: signature.time_ago + " ago"
          });
        }).join("");
        $("signatures.ajax-update tbody").html(signatures_html);

        // did anything change? if no, wait longer til next check.
        if (_.isEqual(data, previousSignatures)) {
          getSignaturesInterval *= 2;
        } else {
          getSignaturesInterval = 2000;
        }
        previousSignatures = data
        window.setTimeout(getSignatures, getSignaturesInterval);
      },
      error: function() {
        window.setTimeout(getSignatures, getSignaturesInterval);
      }
    });
  }

  var zip_pattern = '\\d{5}(-?\\d{4})?';

  if($('#petition-tool').length != 0) {
    window.setTimeout(getSignatures, getSignaturesInterval);

    if ($('#location.require').length) {
      $('#signature_zipcode').attr('required', 'required')
      $('#signature_zipcode').attr('pattern', zip_pattern);
    }
  }

  var toggle_intl = function(){
    $('.intl-toggle').toggle();
    height_changed();
    if ($('#location.require').length) {
      if ($('.intl:visible').length) {
        $('#signature_zipcode').removeAttr('required');
        $('#signature_zipcode').removeAttr('pattern');
        $('#signature_city, #signature_country_code').attr('required', 'required');
      } else {
        $('#signature_zipcode').attr('required', 'required')
        $('#signature_zipcode').attr('pattern', zip_pattern);
        $('#signature_city, #signature_country_code').removeAttr('required');
      }
    }
  }

  if(typeof international_only != 'undefined' && international_only){
    toggle_intl();
    $('.intl-toggler').hide();
    $('#signature_zipcode').removeAttr('required');
  }

  $('.intl-toggler').click(function(e) {
    toggle_intl();
  });

});
