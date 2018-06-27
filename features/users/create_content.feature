@javascript
Feature: Create Content
  In order to protect the Internet (and such things)
  An activist
  Should be able to create content

  Background:
    Given I exist as an activist

  Scenario: Activist logs in and sets up to create some content
    When I create a vanilla action
    Then I get the unpublished petition page
