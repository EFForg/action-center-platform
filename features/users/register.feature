@javascript
Feature: Register

  Scenario: A User creates an account
    When I go to "/register"
    And I fill in "Email" with "user@example.com"
    And I fill in "Password" with "a strong enough password"
    And I fill in "user_password_confirmation" with "a strong enough password"
    And I press "Sign up"
    Then I should not see "Error"

  Scenario: Users are not notified when email uniqueness validation fails
    Given a user with the email "user@example.com"
    When I go to "/register"
    And I fill in "Email" with "user@example.com"
    And I fill in "Password" with "a strong enough password"
    And I fill in "user_password_confirmation" with "a strong enough password"
    And I press "Sign up"
    Then I should not see "Error"
    And I should see "a confirmation link has been sent to your email address"
    And the email "Did you forget your password?" should go to "user@example.com"

  Scenario: Users should not see a success message when validation fails
    Given a user with the email "user@example.com"
    When I go to "/register"
    And I fill in "Email" with "something other than an e-mail address"
    And I fill in "Password" with "a strong enough password"
    And I fill in "user_password_confirmation" with "a strong enough password"
    And I press "Sign up"
    Then I should not see "a confirmation link has been sent to your email address"
