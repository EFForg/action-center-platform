$(document).on("ready", function() {

  var emailSignupForm = '<div class="email-signup">I <input type="radio" name="subscribe" value="1" checked id="do-subscribe" > <label class="radio-inline" for="do-subscribe">want</label> <input type="radio" name="subscribe" value="0" id="do-not-subscribe"> <label class="radio-inline" for="do-not-subscribe">do not want</label> to receive the EFF newsletter and emails about other EFF campaigns.</div>';

  var emailsSent = 0;
  var allEmailSent = function () {
    $(".email-tool-success-share").delay(500).slideDown(600, height_changed);
    $(".step2-intro").delay(500).slideUp(null, height_changed);
    $(".legislator-label.common-fields").delay(500).slideUp(null, height_changed);
    var action_id = $("[data-action-id]").attr("data-action-id");
    var url = "/tools/message-congress?action_id=" + action_id;
    $.ajax({
      url: url,
      data: {
        action_id:	action_id,
        email:		$('[id="$EMAIL"]').val(),
        first_name:	$('[id="$NAME_FIRST"]').val(),
        last_name:	$('[id="$NAME_LAST"]').val(),
        street_address:	$('[id="$ADDRESS_STREET"]').val(),
        zipcode:	$('[id="$ADDRESS_ZIP5"]').val(),
        city:		$('[id="$ADDRESS_CITY"]').val(),
        update_user_data: $("#update_user_data").prop("checked"),
        subscribe:	$('[name="subscribe"]').prop("checked")
      },
      type: "POST",
      success: function(res) {},
      error: function() {}
    });
  };

  $("#non-us-option").click(function () {
    $("#petition-tool").show();
    $("#congress-message-tool").hide();
    $("#signatures").show();
  });

  var generateCongressForm = function (options) {
    var reps = options.reps;
    var rep_ids = _.map(reps, function(rep) {
      return rep.bioguide_id;
    });

    var emailValues = options.emailValues;
    // Stop character encoding on the subject
    emailValues["$SUBJECT"] =$("<div/>").html(emailValues["$SUBJECT"]).text();

    var congressFormsUrl = $(".congress-message-tool-container").data("congress-forms-url")

    $(".congress-message-tool-container").congressForms({
        bioguide_ids: rep_ids,
        labels: false,
        contactCongressServer: congressFormsUrl,
        values: emailValues || {},
        topic_category: options.topicCategory,
        campaign_tag: options.campaignTag,
        legislatorLabelClasses: "legislator-label",
        submitClasses: "btn action",
        onRender: function () {

          $("html, body").animate({
            scrollTop: $("#congress-message-tool").offset().top
          }, 800);


          $('[id="$CAPTCHA_SOLUTION"]').val("test").hide();
          if ($("body.logged-in").length == 0) {
            $("input[name='$EMAIL']").parent().after(emailSignupForm);
          }
          $("#congressForms-common-fields").after($(".update-user-data-container").show());

          // if the common fields are bundled with a specific legislator's fields, there's only one legislator and don't display the common fields label.
          var common_fields_label = '<h3 class="legislator-label common-fields"><em>Common fields </em></h3>';
          if ($("#congressForms-common-fields.congressForms-legislator-fields").length > 0){
            common_fields_label = "";
          }

          $("#congressForms-common-fields").before('<p class="step2-intro">' + options.extraFieldsExplain + "</p>" + common_fields_label);
          //update-user-data-container
          $("input:radio").screwDefaultButtons({
              image: 'url("/checkbox.png")',
              width: 15,
              height: 15
          });
            // Replace the <label>s with <h3>s
          $(".legislator-label").replaceWith(function () {
              var attrs = { };
              $.each($(this)[0].attributes, function(idx, attr) {
                  attrs[attr.nodeName] = attr.nodeValue;
              });
              return $("<h3 />", attrs).append($(this).contents());
          });
          $.each($("select", ".congress-message-tool-container"), function (ind, el) {
            var defaultText = "Select an option";
            if ($(el).attr("id") === "$TOPIC") {
              defaultText = "Choose a topic";
            }
            if ($(el).attr("id") === "$NAME_PREFIX") {
              defaultText = "Your prefix";
            }
            $(el).prepend('<option value="">'+defaultText+"</option>");

            // if, for topic, we already have a "selected" attribute, don't change it.
            if ($(el).attr("id") !== "$TOPIC" || $(el)[0].selectedIndex == 1){
              $(el)[0].selectedIndex = 0;
            }
          });
          $("select[id='$NAME_PREFIX']", ".congress-message-tool-container").change(function(){
            if ($(this)[0].selectedIndex !== 0){
              var prefix = $("option:selected", $(this)).text().trim();
              var that = this;
              $("select[id='$NAME_PREFIX']", ".congress-message-tool-container").each(function(){
                if ($(this)[0].selectedIndex == 0){
                  var fsu = FuzzySetUtil.new_from_select($(this))
                  var match = fsu.match(prefix)
                  if (match && match[0].degree >= .75){
                    $("option", $(this)).each(function(){
                      if ($(this).text().trim() == match[0].term){
                        $(this).attr("selected", "selected")
                      }
                    })
                  }
                }
              });
            }
          });
          $('[id*="STATE"]').each(function(index, el){
            $("option", el).removeAttr("selected");
            if ($('option[value="'+emailValues['$STATE'] +'"]', el).length > 0) {
              $('option[value="'+emailValues['$STATE'] +'"]', el).prop("selected", true);
              $(el).hide();
            } else {
              var state_abbrev = _.findWhere(STATES.ABBREV, {value: emailValues["$STATE"]});
              if (state_abbrev){
                var state_full = _.findWhere(STATES.FULL, {name: state_abbrev.name});
                if (state_full){
                  $('option[value="'+ state_full.value + '"]', el).prop("selected", true);
                }
              }
            }
          });
          $.each(reps, function(index, rep){
              // Add their names
              $('[data-legislator-id="' + rep.bioguide_id + '"] .legislator-label').html("<em>" + rep.first_name + " " + rep.last_name + " </em>");
              $('[data-legislator-id="' + rep.bioguide_id + '"] .legislator-label');
            });

          $(".legislator-info-popover").popover();

          $(".congress-message-tool-container").slideDown(200, height_changed);
          webshims.setOptions("forms", {
            //show custom styleable validation bubble
            replaceValidationUI: true,
            lazyCustomMessages: true
          });

          //start polyfilling

        },
        onLegislatorSubmit: function(legislatorId, legislatorFieldSet) {
          // Subscribe the user if checked
          $(".email-signup").hide();
          $(".update-user-data-container").hide();
          $(".legislator-info-popover").hide();
          legislatorFieldSet.children("h3").append('<span class="info-circle in-progress">Submitting <i class="icon-spin4 animate-spin"></i></span>');
          $("#congressForms-common-fields .form-group").slideUp(400, height_changed);
          $(".form-group", legislatorFieldSet).slideUp(400, height_changed);
          $("input[type=submit]").slideUp(400, height_changed);
          if ($('[id="$CAPTCHA_SOLUTION"]', legislatorFieldSet).length === 0) {
            setTimeout(function () {
              emailsSent++;
              if (emailsSent === rep_ids.length) {
                allEmailSent();
              }
              $("#congressForms-common-fields .form-group").slideUp(400, height_changed);
              $(".form-group", legislatorFieldSet).slideUp(400, height_changed);
              legislatorFieldSet.find("span.info-circle").replaceWith('<span class="info-circle success">Sent <i class="icon-ok-circle"></i></span>');
            }, 2000);
          } else {
            if (typeof(sweet_alert_shown) == "undefined"){
              sweet_alert_shown = true;
              sweetAlert("Take Heed", "There's a captcha for your member of congress.  Please wait until the captcha appears to ensure delivery of your message.");
            }
          }
        },
        onLegislatorSuccess: function(legislatorId, legislatorFieldSet) {
          console.log("EMAIL SUCCESSFULLY SENT");
        },
        onLegislatorError: function(legislatorId, legislatorFieldSet) {
          console.log("EMAIL ACTUALLY FAILED");
          emailsSent++;
          if (emailsSent === rep_ids.length) {
            allEmailSent();
          }
          $(".form-group", legislatorFieldSet).slideUp(400, height_changed);
          legislatorFieldSet.find("span.info-circle").replaceWith('<span class="info-circle success">Sent <i class="icon-ok-circle"></i></span>');
          // All emails are considered sent, even if the server fails
          //legislatorFieldSet.find('span.info-circle').replaceWith('<span class="info-circle error">Error <i class="icon-error-alt"></i></span>');
          console.log(legislatorId, "THIS EMAIL DIDN'T ACTUALLY SEND");
        },
        onLegislatorCaptcha: function(legislatorId, legislatorFieldSet) {
          $(".form-group", legislatorFieldSet).slideUp(400, height_changed);
          legislatorFieldSet.find("span.info-circle").replaceWith('<span class="info-circle warn">Captcha <i class="icon-attention"></i></span>');

          // Collect the attributes in an array
          var attrs = { };
          $.each($(legislatorFieldSet).find(".congressForms-captcha")[0].attributes, function(idx, attr) {
            attrs[attr.nodeName] = attr.nodeValue;
          });
          console.log(attrs);

          // Replace the original input
          if ($("[data-google-recaptcha=true]", legislatorFieldSet).length == 0){
            legislatorFieldSet.find("input.congressForms-captcha").replaceWith('<div class="input-group captcha-form"><input type="text" class="form-control congressForms-captcha"><span class="input-group-btn"><button type="button" class="btn btn-primary congressForms-captcha-button">Submit</button></span></div>');
            // Re-add the attributes
            legislatorFieldSet.find("input.congressForms-captcha").attr(attrs);
            // Remove the buttons
            $(legislatorFieldSet).find("button.congressForms-captcha-button:eq(1)").remove();
          }
        },
        onLegislatorCaptchaSubmit: function(legislatorId, legislatorFieldSet) {
          $(".congressForms-captcha-container", legislatorFieldSet).slideUp(400, height_changed);
          legislatorFieldSet.find("span.info-circle").replaceWith('<span class="info-circle in-progress">Submitting <i class="icon-spin4 animate-spin"></i></span>');
        },
        onLegislatorCaptchaSuccess: function(legislatorId, legislatorFieldSet) {
          emailsSent++;
          if (emailsSent === rep_ids.length) {
            allEmailSent();
          }
          $(".form-group, .recaptcha-div", legislatorFieldSet).slideUp(400, height_changed);
          legislatorFieldSet.find("span.info-circle").replaceWith('<span class="info-circle success">Sent <i class="icon-ok-circle"></i></span>');
        },
        onLegislatorCaptchaError: function(legislatorId, legislatorFieldSet) {
          $(".form-group", legislatorFieldSet).slideUp(400, height_changed);
          legislatorFieldSet.find("span.info-circle").replaceWith('<span class="info-circle error">Error <i class="icon-error-alt"></i></span>');
        },
        success: function () {
          $("#element").slideUp(null, height_changed);
          $(".thank-you").slideDown(null, height_changed);
          var action_id = $("[data-action-id]").attr("data-action-id");

          var url = "/tools/congress-message?action_id=" + action_id;
          $.ajax({
            url: url,
            type: "POST",
            success: function(res) {
              $(".call-tool-body").html('<div class="alert alert-success"><strong>Well done!</strong> You successfully called!</div>')
            },
            error: function() {}
          });
        },
        onDefunctLegislator: function(bioguide, contact_url) {
          var notice = $("<p>").addClass("defunct-notice")
              .text("Sorry, we can't message this legislator at the moment. Contact them at ");

          var link = $("<a>").attr({href: contact_url, target: "_blank"}).text("their website");
          notice.append(link, " instead.");

          var fieldset = $("fieldset[data-legislator-id="+bioguide+"]");
          fieldset.prop("disabled", true);
          fieldset.find(".form-group").remove();
          fieldset.append(notice);
        }
    });
  }
  if ($("#congress-message-tool").length > 0) {
    $("input,textarea,button,select").removeAttr("disabled");
  };

  $("form.congress-message-rep-lookup").on("submit", function(ev) {
    var form = $(ev.currentTarget);
    var tool = $(this).parents(".tool-body").find(".congress-message-tool-container");
    var emailValues = tool.data("email-values");

    if (tool.data("target-bioguide-id")) {
      emailValues["$MESSAGE"] = form.find(".campaign-message").val();

      $("form.congress-message-rep-lookup").html("");

      var bioguide_ids = tool.data("bioguide-id").split(",");
      generateCongressForm({
        reps: _.map(bioguide_ids, function(bioguide_id) {
          return {
            bioguide_id: bioguide_id,
            first_name: "Form",
            last_name: "Fields"
          }
        }),
        topicCategory: tool.data("topic-category"),
        campaignTag: tool.data("campaign-tag"),
        emailValues: emailValues,
        extraFieldsExplain: tool.data("extra-fields-explain")
      });
    } else {

      function show_address_error(error) {
        form.find(".progress-striped").hide();
        form.find("input[type=submit]").show();
        form.find(".alert-danger").remove();
        $("#lookup-address h3").after($('<div class="small alert alert-danger help-block">').text(error));
        height_changed();
      }

      form.find(".progress-striped").show();
      form.find("input[type=submit]").hide();

      var address = form.find("#street_address").val();
      var zip = form.find("#zipcode").val();
      var message = form.find(".campaign-message").val();
      $("input,textarea,button,select", form).attr("disabled", "disabled");

      SmartyStreets.street_address({ street: address,
                                     zipcode: zip })
        .done(function(smart_data) {
          if (smart_data.length > 0) {
            var zip4 = smart_data[0].components.plus4_code;
            if (!zip4) {
              $("input,textarea,button,select", form).removeAttr("disabled");
              show_address_error(App.Strings.addressLookupFailed);
              return;
            }
            var state = smart_data[0].components.state_abbreviation;
            var city = smart_data[0].metadata.county_name;

            emailValues["$ADDRESS_STREET"] = address;
            emailValues["$ADDRESS_CITY"] = city;
            emailValues["$ADDRESS_ZIP4"] = zip4;
            emailValues["$ADDRESS_ZIP5"] = zip;
            emailValues["$STATE"] = state;
            emailValues["$MESSAGE"] = message;

            $.ajax({
              url: "/tools/reps_raw",
              data: { street_address: address, zipcode: zip },
              success: function(data) {
                if (data.error) {
                  show_address_error(data.error);
                } else {
                  var data = _.filter(data, function (rep) {
                    if (rep.chamber === "senate" && tool.data("target-senate"))
                      return true;

                    if (rep.chamber === "house" && tool.data("target-house"))
                      return true;

                    return false;
                  });
                  form.html("");

                  generateCongressForm({
                    reps: data,
                    topicCategory: tool.data("topic-category"),
                    campaignTag: tool.data("campaign-tag"),
                    emailValues: emailValues,
                    extraFieldsExplain: tool.data("extra-fields-explain")
                  });
                }
              },
              error: function(er) {
                show_address_error(er.statusText);
              }
            });
          } else {
            $("input,textarea,button,select", form).removeAttr("disabled");
            show_address_error(App.Strings.addressLookupFailed);
          }
      });
    };
    return false;
  });
});
