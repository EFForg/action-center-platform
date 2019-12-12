//= require Chart.bundle
//= require chartkick
//= require moment
//= require daterangepicker

// Make chart.js redraw charts when we resize the browser
Chart.defaults.global.responsive = true;

$(document).ready(function() {
  $('#date_range').on('focus', function(){
    $(this).daterangepicker({
      locale: { format: 'YYYY-MM-DD' }
    });
  });

  $('#analytics-filters-form').on('click', 'button[type=reset]', function(e) {
    e.preventDefault();
    var $form = $(this).parents('form');
    $form.find('input').val('');
    $form.find('select').val('').trigger('change');
    $form.submit();
  });
});
