@javascript
Feature: Change Email
  A user
  Should be able to change their email

  Background:
    Given I exist as a user

  Scenario: User successfully changes email
    When I log in
    And I change my email address to "new@example.com"
    And I confirm that I changed my email address
    Then I should be on "/edit"
    And I should see "You updated your account successfully, but we need to verify your new email address."
    And I should see "Currently awaiting confirmation for: new@example.com"
    And the email "Confirmation instructions" should go to "new@example.com"

  Scenario: A user had an outstanding password reset token
    When I initiate a password reset request
    And I log in
    And I change my email address to "new@example.com"
    And I confirm that I changed my email address
    Then I should no longer have a hashed reset token in my user record

  Scenario: Users are not notified when email uniqueness validation fails
    Given a user with the email "existing@example.com"
    When I log in
    And I change my email address to "existing@example.com"
    Then I should not see "Error"
    And the element ".field_with_errors" should not exist
    And I should see "You updated your account successfully, but we need to verify your new email address."
    And I should be on "/edit"
    And I should see "Currently awaiting confirmation for: existing@example.com"
    And the email "Did you forget your password?" should go to "existing@example.com"
    And the email "Confirmation instructions" should not go to "existing@example.com"


