//= require Chart.bundle
//= require chartkick
//= require moment
//= require daterangepicker

// Make chart.js redraw charts when we resize the browser
Chart.defaults.global.responsive = true;

$(document).ready(function() {
  $('#date_range').on('focus', function(){
    $(this).daterangepicker({
      locale: { format: 'YYYY-MM-DD' },
      opens: 'left',
      ranges: {
        'Last 7 days': [moment().subtract(6, 'days'), moment()],
        'Last 30 days': [moment().subtract(29, 'days'), moment()],
        'Last 3 months': [moment().subtract(3, 'month'), moment()],
        'Last 6 months': [moment().subtract(6, 'month'), moment()],
      },
      alwaysShowCalendars: true
    })
  }).on('apply.daterangepicker', function() {
    $(this).parents('form').submit();
  });

  $('#analytics-filters-form').on('click', 'button[type=reset]', function(e) {
    e.preventDefault();
    var $form = $(this).parents('form');
    $form.find('input').val('');
    $form.find('select').val('').trigger('change');
    $form.submit();
  });
});
