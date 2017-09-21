$(function() {
  $('#settings .tooltip-help').tooltip();
  var form = $('form.record_activity');
  var disabled = false;
  form.change(function(e) {
    if (!e.originalEvent) {
      $(e.target).submit();
      $('.savedLabel').remove();
      var savedText = $('<span/>').addClass('savedLabel').css({'font-weight': 'bold'}).text('Saved');
      $('.email-signup').last().append(savedText);
      setTimeout(function () {
        savedText.fadeOut(500);
      }, 1000)
    }
  });
});
