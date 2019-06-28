(function() {
  var goto = function(id) {
    $('#content form .page:visible').fadeOut(100, function() {
      $('#nav .active').removeClass('active');
      $('#nav a[href=' + id +']').addClass('active');
      $('#content form .page' + id).fadeIn(100, reflowEpicEditor);

      $('#content form .page' + id).find('input[type=text],textarea').first().focus();
      window.scrollTo(0, 0);
    });
  };

  $(window).on('hashchange', function() {
    goto(window.location.hash);
  });

  $(document).on('ready', function() {
    if (window.location.hash.length)
      goto(window.location.hash);
  });
})();

