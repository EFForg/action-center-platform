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

  $('#analytics-filters-form').on('change', '#date_text', function(e) {
    var start, stop = new Date();
    stop.setHours(0);
    stop.setMinutes(0);
    stop.setSeconds(0);

    start = new Date(stop.getTime());

    switch($('option:selected', e.target).val()) {
    case 'Last 7 days':
      start.setDate(stop.getDate() - 7);
      break;
    case 'Last 30 days':
      start.setDate(stop.getDate() - 30);
      break;
    case 'Last 3 months':
      start.setMonth(stop.getMonth() - 3);
      break;
    case 'Last 6 months':
      start.setMonth(stop.getMonth() - 6);
      break;
    }

    $('#date_range').daterangepicker({
      startDate: start, endDate: stop
    });

    $(e.target.form).submit();
  });

  $('#analytics-filters-form').on('click', 'button[type=reset]', function(e) {
    e.preventDefault();
    var $form = $(this).parents('form');
    $form.find('input').val('');
    $form.find('select').val('').trigger('change');
    $form.submit();
  });
});
