@javascript
Feature: Show all signatures and allow download of signatures
  An interested member of the community
  Should be able to see all signatures on a petition 
  And download signatures as a CSV file

  Scenario: A user views a petition and they should see all signatures
    Given A petition exists and show all signatures is enabled
    When I visit an action page
    Then I should see "All Signatures"
    And I should see "Download CSV"
    When I click "Download CSV"
    Then I should receive a CSV file
