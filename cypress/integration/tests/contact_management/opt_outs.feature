Feature: Permissions - opt-outs

  Scenario: Verify that user Campaigns Limited can't Add new Opt-outs
    Given Login as "campaignsLimited"
    And Open chatbot "chatbotForAutomation"

    When Open "Contact Management->Opt-outs" menu item
    And Wait "2000"
    Then Element "contactManagement.optOuts.addContactButton" should "not.exist"

  Scenario: Verify that user Campaigns StandardLimited can Add Opt-outs and can't delete them
    Given Login as "campaignsStandard"
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Opt-outs" menu item

    When Click on "contactManagement.optOuts.addContactButton"
    And Create random number and save it as "randomNumber"
    And Type "myemail_${randomNumber}@domain.com" in "contactManagement.optOuts.emailInput"
    And Click on "contactManagement.optOuts.saveOptOut"

    Then Type "myemail_${randomNumber}@domain.com{enter}" in "contactManagement.optOuts.searchInput"
    And Wait "1000"
    And Tag "p" with text "myemail_${randomNumber}@domain.com" should "exist"
    And Element "contactManagement.optOuts.deleteButtons" should "not.exist"

  Scenario: Verify that user Campaigns Admin can Add/Search/Delete Opt-outs
    Given Login as "campaignsAdmin"
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Opt-outs" menu item

    When Click on "contactManagement.optOuts.addContactButton"
    And Create random phone number and save it as "phone"
    And Click on "contactManagement.optOuts.phoneDropDown"
    And Click on tag "li" which contains text "PhoneNumber"
    And Type "${phone}" in "contactManagement.optOuts.phoneInput"

    When Intercept "${GRAPHQL_URL}graphql" with "createOptOutEntry" keyword in the response as "searchRequest"
    And Click on "contactManagement.optOuts.saveOptOut"
    And Wait for "searchRequest" and save it as "searchResponse"
    Then Verify that response "searchResponse" has status code "200"
    Then Type "${phone}" in "contactManagement.optOuts.searchInput"
    And Wait "1000"
    And Tag "p" with text "${phone}" should "exist"

    When Click on "contactManagement.optOuts.deleteFirstRowButton"
    And Click on "contactManagement.optOuts.confirmDeleteButton"
    And Wait "1000"
    Then Type "${phone}" in "contactManagement.optOuts.searchInput"
    And Wait "1000"
    And Tag "p" with text "${phone}" should "not.exist"

  Scenario: TMD-86: Opt In an Opted out contact
  Test opt outs contact and then it removes this email and number from Opt-Outs page and
  checks that it's possible to opt out this contact again
    Given Login as "campaignsAdmin"
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Contact Lists" menu item
    And Save "qwert" as "contactListName"

    And Find "${contactListName}"
    And Verify that page contains text "1–1 of 1"
    And Click on tag "div[role='group']>button" which contains text "View"
    And Wait for element "contactManagement.contactLists.EditContact"
    And Optout first contact if opted-In
    And Get the opted out the PhoneNumber and EMail

    When Open "Contact Management->Opt-outs" menu item
    And Verify that page title is "Opt-outs"
    And Find "${email}"
    And Verify that page contains text "1–1 of 1"
    And Click on "contactManagement.optOuts.deleteFirstRowButton"
    And Click on "contactManagement.optOuts.confirmDeleteButton"
    And Check that notification message "Opt-out contact removed" appeared

    And Find "${phoneNumber}"
    And Verify that page contains text "1–1 of 1"
    And Click on "contactManagement.optOuts.deleteFirstRowButton"
    And Click on "contactManagement.optOuts.confirmDeleteButton"
    And Check that notification message "Opt-out contact removed" appeared

    Then Open "Contact Management->Contact Lists" menu item
    And Verify that page title is "Contact Lists"
    And Find "${contactListName}"
    And Verify that page contains text "1–1 of 1"
    And Click on "contactManagement.contactLists.viewFirstRow"
    And Wait for element "contactManagement.contactLists.EditContact"
    And Element "contactManagement.optOuts.optButton" should "exist"

  Scenario: Exporting Opt-Outs
    Given Login using random user from the list
      | viewOtherOfficesCampaigns |
      | campaignsStandard         |
      | campaignsAdmin            |
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Opt-outs" menu item
    And Intercept "${MESSAGE_API_DOMAIN}opt-out-contacts/exported*" as "downloadRequest"
    And Add reload event listener
    When Click on "contactManagement.optOuts.exportOptsOuts"
    And Wait for "downloadRequest" network call
    Then Verify that download folder contains "opt-out-contacts.csv"
