Feature: Contacts

  Scenario: TMD-14: Viewing and Exporting contacts
    Given Login using random user from the list
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    When Open "Contact Management->Contacts" menu item
    Then Verify that page title is "Contacts"
    And Verify that selector "contactManagement.contacts.contactRow" contains more than "1" elements

    When Add reload event listener
    And Click on "contactManagement.contacts.downloadContacts"
    Then Verify that download folder contains "student-profiles.csv"
    And Verify that file "student-profiles.csv" from download folder contains text "Phone Number"