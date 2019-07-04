@javascript @billy
# Feature: Submit messages to congress
#
#   Background:
#     And a congress message campaign exists
#
#   Scenario: Users can sign up for a partner newsletter when contacting congress
#     Given a partner named "The Watchers Council" with the code "twc" exists
#     And "The Watchers Council" is a partner on the action
#     When I browse to the action page with a "The Watchers Council" newsletter signup
#     And I fill in "street_address" with "815 Eddy Street"
#     And I fill in "zipcode" with "94109"
#     And I press "Submit your message"
#     And I fill in the required fields for Nancy Pelosi
#     And I sign up for the newsletter of the partner with code "twc"
#     And I trigger a click on the element ".btn.action"
#     Then I should see "Sent"
#     And there should be a persisted Subscription with:
#         |first_name|Buffy|
#         |last_name|Summers|
#         |email|bsummers@ucsunnydale.edu|
#         |partner_id|1|
#
#   Scenario: Embedded actions can target specific congress members
#     When I browse to an embedded action targetting Nancy Pelosi and Kamala Harris
#     Then I should not see "Look up your representatives"
#     When I press "Submit your message"
#     And I fill in the required fields for Nancy Pelosi and Kamala Harris
#     And I trigger a click on the element ".btn.action"
#     Then I should see "Sent"
