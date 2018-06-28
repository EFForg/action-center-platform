@javascript
Feature: Promoted users must use strong passwords
  A newly promoted activist will need to enter a new password upon promotion

  Background:
    Given I exist as a user

  Scenario: A user is promoted to activist thus needs to supply a strong password
    When I am made into an activist
    Then I am prevented from using the app until I supply a strong password
