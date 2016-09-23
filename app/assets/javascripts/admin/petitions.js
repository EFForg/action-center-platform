$(document).ready(function() {
  $("body.petitions-show input[type=checkbox].select-all").click(function(e) {
    $(this).parents("form").find("input[type=checkbox]").prop("checked", this.checked);
  });
});

