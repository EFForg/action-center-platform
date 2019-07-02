//= require jquery
//= require admin/tabs
//= require admin/editor
//= require admin/gallery
//= require admin/action_pages

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
