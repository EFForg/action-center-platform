@javascript
Feature: Destroy topic categories
  An admin should be able to destroy topic categories

  Background:
    Given I exist as an activist
    And I am logged in
    And there is a persisted TopicCategory

  Scenario:
    When I am on "/admin/topics"
    And I click the element ".delete-category-btn"
    Then there should not be a persisted TopicCategory
