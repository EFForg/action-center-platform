@javascript
Feature: Destroy topics
  An admin should be able to destroy topics

  Background:
    Given I exist as an activist
    And I am logged in
    And there is a persisted TopicCategory
    And it has a persisted item belonging to topic_sets
    And that has a persisted item belonging to topics with:
       |name|a topic|

  Scenario:
    When I am on "/admin/topics"
    And I click the element ".topic_set_edit .delete-btn"
    Then there should not be a persisted Topic
