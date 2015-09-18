$(document).on('ready', function() {
  if($('#call-tool').length > 0){
    var call_campaign_id = $('[data-call-campaign-id]').attr('data-call-campaign-id');
    var url = '/tools/call_required_fields?call_campaign_id=' + call_campaign_id;
    var required_location;

    var $phone_number_field = $(document.getElementById('phone-input').text);
    var $zip_field = $(document.getElementById('zip-input').text);
    var $street_address_field = $(document.getElementById('street-address-input').text);

    $.ajax({
      url: url,
      success: function(res){
        var $container = $('#call-tool-form-container');

        required_location = res.userLocation;

        $('.call-tool-submit').removeAttr('disabled');
        $container.html("");
        if(required_location == "postal"){
          $container.append($phone_number_field);
          $container.append($zip_field);
        }
        if(required_location == "latlon"){
          $container.append($phone_number_field);
          $container.append($street_address_field);
          $container.append($zip_field);
        }
      }
    });

    function submit_call_request(phone, location, zip_code, street_address, action_id, call_campaign_id, update_user_data){
      var url = '/tools/call?action_id=' + encodeURIComponent(action_id) +
                '&call_campaign_id=' + encodeURIComponent(call_campaign_id) +
                '&phone=' + encodeURIComponent(phone) +
                '&location=' + encodeURIComponent(location) +
                (street_address == '' ? '' : '&street_address=' + encodeURIComponent(street_address)) +
                '&zipcode=' + encodeURIComponent(zip_code) +
                '&update_user_data=' + encodeURIComponent(update_user_data);
      $.ajax({
        url: url,
        type: 'POST',
        success: function(res) {
        },
        error: function() {}
      });
    }

    function determine_location(cb, zip_code, street_address){
      if(required_location == "latlon"){
        $.ajax({
          url: '/smarty_streets/street_address/?street=' + encodeURIComponent(street_address) + '&zipcode=' + encodeURIComponent(zip_code),
          success: function(res){
            if(res.length == 1){
              var lat = res[0].metadata.latitude;
              var lng = res[0].metadata.longitude;
              cb(null, lat + ',' + lng);
            }
          },
          error: function(err){
            cb(err);
          }
        });
      } else if (required_location == "postal") {
        cb(null, zip_code)
      }
    }

    function show_form(){
      $('.call-body-phone-saved').addClass('hidden');
      $('.tool-title.precall').removeClass('hidden');
      $('.tool-title.postcall').addClass('hidden');
      $('.call-body-phone-not-saved').removeClass('hidden');
      $('.call-body-active').addClass('hidden');
    }
    function hide_form(){
      $('.tool-title.precall').addClass('hidden');
      $('.tool-title.postcall').removeClass('hidden');
      $('.call-body-phone-not-saved').addClass('hidden');
      $('.call-body-active').removeClass('hidden');
      $('.call-body-phone-saved').addClass('hidden');
    }

    $('form.call-tool, form.call-tool-saved').on('submit', function(ev) {
      var form = $(ev.currentTarget);

      var update_user_data = $('#update_user_data', form).val();
      var phone_number = $phone_number_field.val().replace(/[^\d.]/g, '');
      var street_address = $street_address_field.val();
      var zip_code = $zip_field.val().replace(/[^\d.]/g, '').slice(0,5);
      var action_id = $('[name="action-id"]', form).val();

      if(!isValidPhoneNumber(phone_number)){
        rumbleEl($phone_number_field);
      } else if(zip_code.length != 5) {
        rumbleEl($zip_code_field);
      } else {
        determine_location(function(err, location){
          hide_form();
          height_changed();

          submit_call_request(phone_number, location, zip_code, street_address, action_id, call_campaign_id, update_user_data);

        }, zip_code, street_address);
      }
      return false;
    });

    $('.call-tool-try-again').on('click', function(ev){
      show_form();
      height_changed();
      return false;
    });
    $('.call-tool-different-number').on('click', function(ev){
      show_form();
      $('#inputPhone').val('').focus();
      height_changed();
      return false;
    });
  }
});
