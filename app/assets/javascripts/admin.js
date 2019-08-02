//= require jquery
//= require jquery-ujs
//= require select2
//= require admin/tabs
//= require admin/editor
//= require admin/gallery
//= require admin/action_pages
//= require admin/analytics

function debounce(fn, time) {
  var timeout;

  return function() {
    var context = this, args = arguments;

    if (timeout)
      clearTimeout(timeout);

    timeout = setTimeout(function() {
      timeout = null;
      fn.apply(context, args);
    }, time);
  };
}

$(document).on('ready', function() { $('select').select2({ 'width': '100%' }); });
