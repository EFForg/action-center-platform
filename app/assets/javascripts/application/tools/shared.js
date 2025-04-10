function show_progress_bars() {
  $(".progress-striped").show();
  $("#tools :submit").hide();
  $("#tools input,textarea,button,select", $(this)).attr("disabled", "disabled");
}

function show_error(error, form) {
  $(".progress-striped").hide();
  form.find(":submit").show();
  form.find(".alert-danger").remove();
  $("#errors").append($('<div class="small alert alert-danger help-block">').text(error));
  $("#tools input,textarea,button,select", form).removeAttr("disabled");
}

function update_tabs(from, to) {
  $(".page-indicator div.page" + from).removeClass('active');
  $(".page-indicator div.page" + to).addClass('active');
}
