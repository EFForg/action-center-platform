Feature: Create Content
  In order to protect the internet (and such things)
  An activist
  Should be able to create content

    Scenario: User is not signed up
      Given I exist as an activist
        And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I return to the site
      Then I should be signed in
      When I visit the admin page
      Then I am shown admin controls
