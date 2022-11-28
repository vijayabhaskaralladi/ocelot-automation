Feature: Integrations - Slate

  Background:
    Given Login as "defaultUser"
    And Open chatbot "centennialUniversity"
    And Create random number and save it as "randomNumber"
    And Intercept "${GRAPHQL_URL}graphql" with "getLiveChatOperator" keyword in the response as "liveChatRequest"
    And Open "Integrations->Applications" menu item
    And Wait for "liveChatRequest" network call
    And Retrieve "request.headers.authorization" from "liveChatRequest" and save as "token"
    And Retrieve "request.headers.x-contextual-entity" from "liveChatRequest" and save as "contextualEntity"

  Scenario: Creating Contact Lists from slate
    When Enable Slate
      | authToken        | ${token}                                         |
      | contextualEntity | ${contextualEntity}                              |
      | baseSlateQuery   | https://oce.test.technolutions.net/manage/query/ |

    When Open "Contact Management->Contact Lists" menu item
    And Click on "contactManagement.contactLists.addContactListButton"
    And Click on tag "button" which contains text "slate query"
    And Click on "[aria-label='1 Sales Demo Query']"
    And Click on tag "button" which contains text "Next"
    And Configure columns for contact list
      | header1 | First Name    |
      | header2 | Last Name     |
      | header3 | Email Address |
      | header4 | Phone Number  |
    And Click on "contactManagement.contactLists.nextButton"
    And Type "ContactListFromSlate${randomNumber}" in "contactManagement.contactLists.nameInput"
    And Type "automation{enter}" in "contactManagement.contactLists.tagsInput"
    And Click on "contactManagement.contactLists.createContactListButton"
    And Tag "p" with text "Successfully" should "exist"
    And Tag "p" with text "imported" should "exist"
    And Click on "contactManagement.contactLists.finishButton"

    Then Type "ContactListFromSlate${randomNumber}" in "contactManagement.contactLists.searchInput"
    And Verify that selector "contactManagement.contactLists.tableRows" contains "1" elements
    And Intercept "${GRAPHQL_URL}graphql" with "getLiveChatWhosOnlineStatistics" keyword in the response as "whosOnlineRequest"
    And Click on tag "button" which contains text "View"
    And Wait for "whosOnlineRequest" network call
    And Verify that selector "contactManagement.contactLists.tableRows" contains "10" elements
    And Tag "p" with text "Paul" should "exist"
    And Tag "p" with text "Burke" should "exist"
    And Tag "p" with text "paul.burke@ocelotbot.com" should "exist"
    And Tag "p" with text "+18585396564" should "exist"

  Scenario: Turn off slate integration
    When Disable Slate
      | authToken        | ${token}            |
      | contextualEntity | ${contextualEntity} |
    Then Open "Contact Management->Contact Lists" menu item
    And Verify that page title is "Contact Lists"
    And Click on "contactManagement.contactLists.addContactListButton"
    And Tag "button" with text "slate query" should "not.exist"
    And Click on "contactManagement.contactLists.closeScreen"

    And Click on "contactManagement.contactLists.actionsDropdownFirstRow"
    And Click on tag "li[role='menuitem']" which contains text "Bulk add"
    And Tag "button" with text "slate query" should "not.exist"
    And Click on "contactManagement.contactLists.closeScreen"
