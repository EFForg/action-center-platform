$(document).ready(function() {
  var stateLevelTarget = $("#action_page_email_campaign_attributes_state");
  var stateLevelTargetSelection = $("#state-level-target-selection");

  if (stateLevelTarget.val() === "")
    stateLevelTargetSelection.hide();

  stateLevelTarget.on("change", function() {
    if (stateLevelTarget.val() !== "")
      stateLevelTargetSelection.show();
    else
      stateLevelTargetSelection.hide();
  });
});

