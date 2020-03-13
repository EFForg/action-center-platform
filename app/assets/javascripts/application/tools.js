
$('body').on('click', '.thank-you a[href$=donate]', function(e) {
  window.top.location.href = e.target.href;
});
