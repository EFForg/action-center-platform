//= require chartjs
//= require moment
//= require chartkick
//= require EpicEditor
//= require jquery-sortable/jquery-sortable
//= require bootstrap-daterangepicker
//= require jquery.fix.clone
//= require admin/file_uploads
//= require admin/s3_uploads.js
//= require s3_cors_fileupload
//= require bootstrap-sass/bootstrap/tab
//= require bootstrap-responsive-tabs

$(document).on('ready', function() {

  var editor = initEpicEditor('action-page-description', 'description');
  var editor2 = initEpicEditor('action-page-what-to-say', 'what-to-say');
  var editor3 = initEpicEditor('epic-petition-description', 'petition-description');
  var editor4 = initEpicEditor('epic-action-summary', 'action-summary');
  var editor5 = initEpicEditor('epic-email-text', 'email-text');
  var editor6 = initEpicEditor('epic-victory-message', 'victory-message');

  $('input#date_range').click(function(){
    $('input#date_range').daterangepicker({
      format: "YYYY-MM-DD",
      startDate: date_start,
      endDate: date_end
    });
    $('input#date_range').on('apply.daterangepicker', function(ev, picker){
      date_start = picker.startDate.format("YYYY-MM-DD");
      date_end = picker.endDate.format("YYYY-MM-DD");
      $('.daterangepicker').hide();
    });
    $('input#date_range').on('cancel.daterangepicker', function(ev, picker){
      $('.daterangepicker').hide();
    });
  });

  $(".edit-action .panel-heading").click(function(){
    setTimeout(function() {editor2.reflow()}, 100);
  });

  // This is a hack to make the "edit petition description" Epiceditor display at the right height when the panel is openened.
  $("#action_page_enable_petition").change(function(){
    setTimeout(function(){editor3.reflow()}, 100);
  });

  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    if(typeof editor5 != 'undefined'){
      editor5.reflow();
      editor6.reflow();
    }
  });

  $('.thumbnail').on('click', function (ev) {
    var image = $(ev.currentTarget);
    var md  = image.attr('src');
    $('.markdown-image-code').text(md);
    return false;
  });

  // the campaign tag should mirror the title, unless changed
  // this is for tracking analytics and will be delivered to congress-forms
  var campaign_tag_changed = false;
  var $title = $('#action_page_title');
  var campaign_tag_selector = '#action_page_email_campaign_attributes_campaign_tag';
  var $campaign_tag = $(campaign_tag_selector);
  if($title.val() != $campaign_tag.val())
    campaign_tag_changed = true;
  $title.keyup(function(e){
    var $campaign_tag = $(campaign_tag_selector);
    if(!campaign_tag_changed){
      $campaign_tag.val($title.val());
      console.log($campaign_tag.val());
    }
  });
  $campaign_tag.on("change keyup",function(){
    campaign_tag_changed = true;
  });

  if (window.location.hash.length) {
    $('a[data-tab="'+window.location.hash.slice(1)+'"]').tab('show');
    window.scrollTo(0, 0); // Otherwise page starts scrolled to initial tab location
  }
  $('.edit-action .nav-tabs a').on('show.bs.tab', function(e) {
    var anchor = $(e.target).data('tab');
    $('#anchor').val(anchor);
    history.pushState(null,null,'#' + anchor);
  });
  $('.action_pages-index .nav-tabs a').on('show.bs.tab', function(e) {
    var anchor = $(e.target).data('tab');
    $('#anchor').val(anchor);
    history.pushState(null,null,'#' + anchor);
  });

  var updated_at = $('#action_page_updated_at');
  if (updated_at.length > 0) {
    var t = window.setInterval(function() {
      $.get(updated_at.data('url'), { updated_at: updated_at.val() },
        function(data) {
          if (data.updated) {
            $('#action-page-form').submit(function(e) {
              if (confirm('Are you sure? This page has been updated since you started editing.')) {
                return;
              }
              e.preventDefault();
            });
            window.clearInterval(t);
          }
        }
      );
    }, 10000);
  }

  var preview_button = $('#action-page-preview').click(function() {
    $('#action-page-form').clone().attr('action', preview_button.attr('href')).
                                   attr('target', '_blank').
                                   submit();
    return false;
  });

  $('#date_submit').click(function(){
    var base_url = window.location.pathname;
    var hash = window.location.hash;
    window.location = base_url + "?date_start=" + date_start + "&date_end=" + date_end + hash;
    return false;
  });

  var $target_house = $('#action_page_email_campaign_attributes_target_house');
  var $target_senate = $('#action_page_email_campaign_attributes_target_senate');
  var $target_email = $('#action_page_email_campaign_attributes_target_email');
  var $addresses = $('#action_page_email_campaign_attributes_email_addresses');
  var $target_bioguide_id = $('#action_page_email_campaign_attributes_target_bioguide_id');
  var $bioguide_id = $('#action_page_email_campaign_attributes_bioguide_id');
  var $topic_category = $('#topic_category_form_group');
  var $campaign_tag = $('#campaign_tag_form_group');
  var $text_replacement = $('#text_replacement_form_group');

  function setup_target_ux($target_checkbox, $text_field, hide_cf_fields, show_alt_text_fields){
    if($target_checkbox.is(':checked')){
      $target_house.prop('disabled', true);
      $target_senate.prop('disabled', true);
      $target_bioguide_id.prop('disabled', true);
      $target_email.prop('disabled', true);
      $bioguide_id.hide();
      $addresses.hide();

      if(hide_cf_fields){
        $topic_category.hide();
        $campaign_tag.hide();
      }
      if(show_alt_text_fields){
        $text_replacement.show();
      }

      $text_field.show();
      $target_checkbox.prop('disabled', false);
    } 
  }

  function create_target_listener($target_checkbox, $text_field, toggle_cf_fields, toggle_alt_text_fields){
    $target_checkbox.change(function(e){
      if($(this).is(':checked')){
        $target_house.prop('checked', false);
        $target_house.prop('disabled', true);
        $target_senate.prop('checked', false);
        $target_senate.prop('disabled', true);
        $target_bioguide_id.prop('checked', false);
        $target_bioguide_id.prop('disabled', true);
        $target_email.prop('checked', false);
        $target_email.prop('disabled', true);

        $target_checkbox.prop('checked', true);
        $target_checkbox.prop('disabled', false);
      } else {
        $target_house.prop('disabled', false);
        $target_senate.prop('disabled', false);
        $target_bioguide_id.prop('disabled', false);
        $target_email.prop('disabled', false);
      }
      $text_field.toggle();
      
      if(toggle_cf_fields){
        $topic_category.toggle();
        $campaign_tag.toggle();
      }
      if(toggle_alt_text_fields){
        $text_replacement.toggle();
      }
    });
  }

  create_target_listener($target_email, $addresses, true, false);
  create_target_listener($target_bioguide_id, $bioguide_id, false, true);

  setup_target_ux($target_email, $addresses, true, false);
  setup_target_ux($target_bioguide_id, $bioguide_id, false, true);
});


// Bootstrap popovers and tooltips
$('.action_pages-index i.has-tooltip').tooltip();

var popovers = "#protip2, #protip3, .photo-specs-popover, .photo-popover";
$(popovers).popover();

$(popovers).on('shown.bs.popover', function(){
  $(".popover").click(function(e){
    e.stopPropagation();
  });
  $("body").click(function(){
    $(popovers).popover('hide');
    $("body").off('click');
  });
});

// Prevent scrolling to the top of the page when clicking on protip popovers.
$( 'a[href="#"]' ).click( function(e) {
      e.preventDefault();
   } );

// Make chart.js redraw charts when we resize the browser
Chart.defaults.global.responsive = true;

// Bootstrap responsive tabs: https://github.com/openam/bootstrap-responsive-tabs
fakewaffle.responsiveTabs(['xs']);

