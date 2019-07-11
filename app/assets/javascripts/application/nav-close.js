$(document).click(function(event) {
  $navmenu = $('#nav-menu');
  $target = $(event.target);
  if(!$target.closest('#nav-menu').length &&
  $('#nav-menu').is(":visible")) {
    $('#nav-menu').css('display', 'none');
  }
  else {
      $('#nav-menu').css('display', 'inline-block');
  }
})
