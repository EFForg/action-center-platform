$(document).ready(function() {
  $("table#congress_message_tabulation_by_date").each(function() {
    $.ajax({
      url: this.dataset.fills_url,
      success: function(data) {
        var tbody_html;
        var total_count = 0;
        _.each(data, function(v, k){
          tbody_html += JST['admin/backbone/templates/email_campaign/date_tabulation_row']({
            date: moment(k, "YYYY-MM-DD").format("YYYY-MM-DD"),
            count: v
          });
          total_count += v;
        });
        tbody_html += JST['admin/backbone/templates/email_campaign/date_tabulation_row']({
          date: "Total",
          count: total_count
        });
        $("#congress_message_tabulation_by_date tbody").html(tbody_html);
      }
    });
  });

  $("table#congress_message_tabulation_by_congress").each(function(){
    var table = this;
    Step(
      function fetchBreakdownAndNames(){
        ajax_get(table.dataset.fills_url, this.parallel());
        ajax_get(table.dataset.legislators_url, this.parallel());
      },
      function processAndDisplay(e, breakdown, names){
        if(e) return console.log(e);

        var members_sorted = _.keys(breakdown).sort();

        var tbody_html;
        var total_count = 0;

        _.each(members_sorted, function(bioid){
          tbody_html += JST['admin/backbone/templates/email_campaign/congress_tabulation_row']({
            bioguide_id: bioid,
            staffer_report_url: table.dataset.staffer_report_url.replace('placeholder', bioid),
            name: (names[bioid] || { full_name: "Unknown" }).full_name,
            count: breakdown[bioid]
          });
          total_count += breakdown[bioid];
        });
        tbody_html += JST['admin/backbone/templates/email_campaign/congress_tabulation_row']({
          bioguide_id: "",
          staffer_report_url: "",
          name: "Total",
          count: total_count
        });
        $("#congress_message_tabulation_by_congress tbody").html(tbody_html);
      }
    );
  });

  $(".staffer-report").each(function() {
    var report = this;
    var bioid = this.dataset.bioid;
    ajax_get(this.dataset.legislators_url, function(e, data) {
      if(e) return console.log(e);

      var title = data[bioid]["type"] == "senate" ? "Sen." : "Rep.";
      $(".member_name", report).text(title + " " + data[bioid]["full_name"]);
    });
  });
});
