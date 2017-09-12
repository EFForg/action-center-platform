@javascript @billy
Feature: Submit messages to congress

  Background:
    Given a stubbed phantomdc
    And a congress member exists
    And a congress message campaign exists

  Scenario: Users can sign up for a partner newsletter when contacting congress
    Given a partner named "The Watchers Council" with the code "twc" exists
    And "The Watchers Council" is a partner on the action
    And I exist as a user
    And I am logged in
    When I browse to the action page
    And I fill in "street_address" with "815 Eddy Street"
    And I fill in "zipcode" with "94109"
    And I press "Submit your message"
    And I fill in "$NAME_FIRST" with "Buffy"
    And I fill in "$NAME_LAST" with "Summers"
    And I fill in "$EMAIL" with "bsummers@ucsunnydale.edu"
    And I sign up for the newsletter of the partner with code "twc"
    And I trigger a click on the element ".btn.action"
    Then I should see "Sent"
    And there should be a persisted Subscription with:
        |first_name|Buffy|
        |last_name|Summers|
        |email|bsummers@ucsunnydale.edu|
        |partner_id|1|
