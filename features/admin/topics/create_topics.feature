@javascript
Feature: Create topics
  An admin should be able to create topics

  Background:
    Given I exist as an activist
    And I am logged in
    And there is a persisted TopicCategory

  Scenario:
    When I am on "/admin/topics"
    And I click the element ".create-btn"
    And I fill in "topic[name]" with "newly made topic 1"
    And I click the first ".add_topic"
    And I pause a moment

    And I fill in "topic[name]" with "newly made topic 2"
    And I click the first ".add_topic"
    And I pause a moment

    Then I should see "newly made topic 1" within the first ".topic_category .panel-body .topics"
    And I should see "newly made topic 2" within the first ".topic_category .panel-body .topics"
    And there should be a persisted Topic with:
        |name|newly made topic 1|
    And there should be a persisted Topic with:
        |name|newly made topic 2|

