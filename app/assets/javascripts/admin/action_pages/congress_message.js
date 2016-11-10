$(document).ready(function() {
  var targetHouse = $("#action_page_congress_message_campaign_attributes_target_house");
  var targetSenate = $("#action_page_congress_message_campaign_attributes_target_senate");
  var targetSpecificLegislators = $("#action_page_congress_message_campaign_attributes_target_specific_legislators");
  var targetBioguideIds = $("#action_page_congress_message_campaign_attributes_target_bioguide_ids");
  var targetCongress = targetHouse.add(targetSenate);

  targetBioguideIds.on("focus", function() {
    targetCongress.prop("checked", false);
    targetSpecificLegislators.prop("checked", true);
  });

  targetSpecificLegislators.on("change", function() {
    if (this.checked) {
      targetCongress.prop("checked", false);
      targetBioguideIds.focus();
    }
  });

  targetCongress.on("change", function() {
    if (targetCongress.filter(":checked").length) {
      targetSpecificLegislators.prop("checked", false);
    } else {
      targetSpecificLegislators.prop("checked", true);
      targetBioguideIds.focus();
    }
  });
});
