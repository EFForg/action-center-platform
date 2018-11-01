$(document).ready(function() {
  $('#tabs a[data-tab="analytics"]').on('click', function(e) {
    // Lazy loading to come.
  });

  $("#date_range").daterangepicker({ format: "YYYY-MM-DD" });

  $("#date_range").on('apply.daterangepicker', function(ev, picker){
    Chartkick.eachChart( function(chart) {
      chart.dataSource = chart.dataSource.split('?')[0] + '?' + $.param({
        date_start: picker.startDate.format("YYYY-MM-DD"),
        date_end: picker.endDate.format("YYYY-MM-DD")
      });
      chart.refreshData();
    });
  });
});
