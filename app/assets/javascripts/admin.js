//= require Chart.bundle
//= require chartkick
//= require moment
//= require EpicEditor
//= require jquery-sortable/jquery-sortable
//= require bootstrap-daterangepicker
//= require jquery.fix.clone
//= require admin/file_uploads
//= require admin/s3_uploads.js
//= require admin/congress_message_tabulation
//= require admin/petitions
//= require admin/epic_editor_helper
//= require_tree ./admin/action_pages
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

  $("#action-page-description").data("editor", editor);
  $("#action-page-what-to-say").data("editor", editor2);
  $("#epic-petition-description-").data("editor", editor3);
  $("#epic-action-summary").data("editor", editor4);
  $("#epic-email-text").data("editor", editor5);
  $("#epic-victory-message").data("editor", editor);

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
    var form = $('#action-page-form').clone()
                 .attr("id", null).css("display", "none")
                 .attr('action', preview_button.attr('href'))
                 .attr('target', '_blank');
    $("body").append(form);
    form.submit();
    return false;
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

  // Bootstrap responsive tabs: https://github.com/openam/bootstrap-responsive-tabs
  fakewaffle.responsiveTabs(['xs']);
});


// Make chart.js redraw charts when we resize the browser
Chart.defaults.global.responsive = true;

