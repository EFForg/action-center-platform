Feature: A user can reset their password

  Background:
    Given a user with the email "me@example.com"

  Scenario: A user resets their password
    When I go to "/password/new"
    And I fill in "Email" with "me@example.com"
    And I press "Send me reset password instructions"
    And I follow the password reset link
    And I fill in "user_password" with "a strong enough password"
    And I fill in "user_password_confirmation" with "a strong enough password"
    And I press "Change my password"
    Then I should see "Your password was changed! You are now signed in."
