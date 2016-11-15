@javascript
Feature: Destroy topic sets
  An admin should be able to destroy topic sets

  Background:
    Given I exist as an activist
    And I am logged in
    And there is a persisted TopicCategory
    And it has a persisted item belonging to topic_sets
    And that has a persisted item belonging to topics

  Scenario:
    When I am on "/admin/topics"
    And I click the element "[data-set-id] td:last-child .delete-btn"
    Then there should not be a persisted Topic
    And there should not be a persisted TopicSet

