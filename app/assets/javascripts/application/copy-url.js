$(function() {
  $('.url-field-share input').val(window.location.href);
  $('.copy-url-share').click(function (e) {
    $('.url-field-share').toggle().find('input').select();
  });
});
