//= require Chart.bundle
//= require chartkick
//= require moment
//= require EpicEditor
//= require jquery-sortable/jquery-sortable
//= require bootstrap-daterangepicker
//= require jquery.fix.clone
//= require admin/file_uploads
//= require admin/s3_uploads.js
//= require s3_cors_fileupload
//= require bootstrap-sass/bootstrap/tab
//= require bootstrap-responsive-tabs

var editor;


$(document).on('ready', function() {

  editor = initEpicEditor('action-page-description', 'description');
  var editor2 = initEpicEditor('action-page-what-to-say', 'what-to-say');
  var editor3 = initEpicEditor('epic-petition-description', 'petition-description');
  var editor4 = initEpicEditor('epic-action-summary', 'action-summary');
  var editor5 = initEpicEditor('epic-email-text', 'email-text');
  var editor6 = initEpicEditor('epic-victory-message', 'victory-message');

  $("#date_control_container").each(function() {
    var date_start = $(this).data("date-start");
    var date_end = $(this).data("date-end");

    var action = $(".date_submit", this)[0];
    var base_url = window.location.pathname;
    action.href = base_url + "?date_start=" + date_start + "&date_end=" + date_end + window.location.hash;

    $("input#date_range", this).daterangepicker({
      format: "YYYY-MM-DD",
      startDate: date_start,
      endDate: date_end
    });

    $("input#date_range", this).on('apply.daterangepicker', function(ev, picker){
      date_start = picker.startDate.format("YYYY-MM-DD");
      date_end = picker.endDate.format("YYYY-MM-DD");
      action.href = base_url + "?date_start=" + date_start + "&date_end=" + date_end + window.location.hash;
      $('.daterangepicker').hide();
    });

    $("input#date_range", this).on('cancel.daterangepicker', function(ev, picker){
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


  $("table#email_tabulation_by_date").each(function() {
    $.ajax({
      url: this.dataset.fills_url,
      success: function(data) {
        var tbody_html;
        var total_count = 0;
        _.each(data, function(v, k){
          tbody_html += JST['admin/backbone/templates/email_campaign/date_tabulation_row']({
            date: moment(k, "YYYY-MM-DD").format("YYYY-MM-DD"),
            count: v
          });
          total_count += v;
        });
        tbody_html += JST['admin/backbone/templates/email_campaign/date_tabulation_row']({
          date: "Total",
          count: total_count
        });
        $("#email_tabulation_by_date tbody").html(tbody_html);
      }
    });
  });

  $("table#email_tabulation_by_congress").each(function(){
    var table = this;
    Step(
      function fetchBreakdownAndNames(){
        ajax_get(table.dataset.fills_url, this.parallel());
        ajax_get(table.dataset.legislators_url, this.parallel());
      },
      function processAndDisplay(e, breakdown, names){
        if(e) return console.log(e);

        var members_sorted = _.keys(breakdown).sort();

        var tbody_html;
        var total_count = 0;

        _.each(members_sorted, function(bioid){
          tbody_html += JST['admin/backbone/templates/email_campaign/congress_tabulation_row']({
            bioguide_id: bioid,
            staffer_report_url: table.dataset.staffer_report_url.replace('placeholder', bioid),
            name: names[bioid].name,
            count: breakdown[bioid]
          });
          total_count += breakdown[bioid];
        });
        tbody_html += JST['admin/backbone/templates/email_campaign/congress_tabulation_row']({
          bioguide_id: "",
          staffer_report_url: "",
          name: "Total",
          count: total_count
        });
        $("#email_tabulation_by_congress tbody").html(tbody_html);
      }
    );
  });

  $(".staffer-report").each(function() {
    var report = this;
    var bioid = this.dataset.bioid;
    ajax_get(this.dataset.legislators_url, function(e, data) {
      if(e) return console.log(e);
      $(".member_name", report).text(data[bioid]['type'] + ". " + data[bioid]['name']);
    });
  });

  var preview_button = $('#action-page-preview').click(function() {
    $('#action-page-form').clone().attr('action', preview_button.attr('href')).
                                   attr('target', '_blank').
                                   submit();
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

        if(toggle_cf_fields){
          $topic_category.hide();
          $campaign_tag.hide();
        }

        if(toggle_alt_text_fields){
          $text_replacement.show();
        }

        $text_field.show();
      } else {
        $target_house.prop('disabled', false);
        $target_senate.prop('disabled', false);
        $target_bioguide_id.prop('disabled', false);
        $target_email.prop('disabled', false);

        if(toggle_cf_fields){
          $topic_category.show();
          $campaign_tag.show();
        }

        if(toggle_alt_text_fields){
          $text_replacement.hide();
        }

        $text_field.hide();
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
