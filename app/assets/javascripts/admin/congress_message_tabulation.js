$(document).ready(function() {
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

        var totalCount = 0;
        var tbody = $("<tbody>");

        _.each(members_sorted, function(bioid){
          var name = (names[bioid] || { full_name: "Unknown" }).full_name;
          var stafferUrl = table.dataset.staffer_report_url.replace('placeholder', bioid);
          var stafferLink = $('<a class="btn btn-default btn-sm">').attr("href", stafferUrl)
                              .html('<i class="icon-clipboard"></i> Staffer Report')[0].outerHTML;
          tbody.append("<tr><td>"+bioid+"</td><td>"+name+"</td><td>"+breakdown[bioid]+"</td><td>"+stafferLink+"</td></tr>");
          totalCount += breakdown[bioid];
        });
        tbody.append("<tr><td></td><td><b>Total</b></td><td><b>" + totalCount + "</b></td><td></td></tr>");
        $("#congress_message_tabulation_by_congress tbody").replaceWith(tbody);
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
