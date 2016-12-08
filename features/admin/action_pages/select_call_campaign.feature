@javascript
Feature: Select Call Power campaign
  As an EFF staff activist
  I want to select a call campaign from a list of those present in Call Power

  Background:
    Given I exist as an activist
    And I am logged in

  Scenario: Activists should be able to enable local affiliations
    When I go to "/admin/action_pages/new"
    And I click "Action Settings"
    And I check "Enable call"
    Then I should see "Call Someone (live)" within "select#action_page_call_campaign_attributes_call_campaign_id option"
