
$(document).on('ready', function() {
  $('form.call-tool, form.call-tool-saved').on('submit', function(ev) {
    var form = $(ev.currentTarget);
    //var url = 'http://eff-call-tool.herokuapp.com/eff_test';
    var phoneNumberEl = $('#inputPhone', form);
    var update_user_data = $('#update_user_data', form);
    var phoneNumber = phoneNumberEl.val().replace(/[^\d.]/g, '');
    if(!isValidPhoneNumber(phoneNumber)){
      rumbleEl(phoneNumberEl);
    } else {
      var action_id = $('[name="action-id"]', form).val();
      var call_campaign_id = $('[data-call-campaign-id]').attr('data-call-campaign-id');
      var url = '/tools/call?action_id=' + action_id + '&call_campaign_id=' + call_campaign_id + '&phone=' + phoneNumber + '&update_user_data=' + update_user_data;
      $('.tool-title.precall').addClass('hidden');
      $('.tool-title.postcall').removeClass('hidden');
      $('.call-body-phone-not-saved').addClass('hidden');
      $('.call-body-active').removeClass('hidden');
      $('.call-body-phone-saved').addClass('hidden');
      height_changed();
      $.ajax({
        url: url,
        type: 'POST',
        success: function(res) {
        },
        error: function() {}
      });
    }
    return false;
  });
  $('.call-tool-try-again').on('click', function(ev){
    $('.call-body-phone-saved').addClass('hidden');
    $('.tool-title.precall').removeClass('hidden');
    $('.tool-title.postcall').addClass('hidden');
    $('.call-body-phone-not-saved').removeClass('hidden');
    $('.call-body-active').addClass('hidden');
    height_changed();
    return false;
  });
  $('.call-tool-different-number').on('click', function(ev){
    $('.call-body-phone-saved').addClass('hidden');
    $('.tool-title.precall').removeClass('hidden');
    $('.tool-title.postcall').addClass('hidden');
    $('.call-body-phone-not-saved').removeClass('hidden');
    $('.call-body-active').addClass('hidden');
    $('#inputPhone').val('').focus();
    height_changed();
    return false;
  });
});
