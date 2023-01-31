Feature: Contacts

  Scenario: Search Contact
    Given Login using random user from the list
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    When Open "Contact Management->Contacts" menu item
    Then Verify that page title is "Contacts"
    And Save "${contactFromContactsPage}" as "number"
    And Add "?startDate=2022-9-31" to the current URL

    When Intercept "${GRAPHQL_URL}graphql" with "listStudentProfiles" keyword in the response as "searchRequest"
    And Find "${number}"
    And Wait for "searchRequest" and save it as "searchRequestResponse"
    Then Verify that response "searchRequestResponse" has status code "200"
    And Verify that selector "contactManagement.contacts.contactRow" contains "1" elements

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