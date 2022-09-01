Feature: Permissions - Canned responses

  Scenario: Viewing/creating Canned Responses
    Given Login using random user from the list
      | liveChatLimited  |
      | liveChatStandard |
      | liveChatAdmin    |
    And Open chatbot "chatbotForAutomation"
    And Create random number and save it as "randomNumber"

    When Open "Live Chat->Canned Responses" menu item
    And Click on "liveChat.cannedResponses.createButton"
    And Type "CannedResponse${randomNumber}" in "liveChat.cannedResponses.titleInput"
    And Type "Response${randomNumber}" in "liveChat.cannedResponses.responseText"
    And Type "automation{enter}" in "liveChat.cannedResponses.tagsInput"
    And Click on "liveChat.cannedResponses.campusesDropdown"
    And Click on tag "span.MuiTypography-displayBlock" which contains text "All Campuses/Offices"
    And Click on "liveChat.cannedResponses.saveButton"

    Then Type "CannedResponse${randomNumber}{enter}" in "liveChat.cannedResponses.searchInput"
    And Tag "p" with text "CannedResponse${randomNumber}" should "exist"

  Scenario: Limited users can't Delete canned response
    Given Login using random user from the list
      | liveChatLimited  |
      | liveChatStandard |
    And Open chatbot "chatbotForAutomation"
    And Create random number and save it as "randomNumber"

    When Open "Live Chat->Canned Responses" menu item
    And Click on "liveChat.cannedResponses.firstCannedResponseItem"
    And Tag "span" with text "Delete" should "not.exist"

  Scenario: Creating and Deleting canned response
    Given Login as "liveChatAdmin"
    And Open chatbot "chatbotForAutomation"
    And Create random number and save it as "randomNumber"

    When Open "Live Chat->Canned Responses" menu item
    And Click on "liveChat.cannedResponses.createButton"
    And Type "CannedResponse${randomNumber}" in "liveChat.cannedResponses.titleInput"
    And Type "Response${randomNumber}" in "liveChat.cannedResponses.responseText"
    And Type "automation{enter}" in "liveChat.cannedResponses.tagsInput"
    And Click on "liveChat.cannedResponses.campusesDropdown"
    And Click on tag "span.MuiTypography-displayBlock" which contains text "All Campuses/Offices"
    And Click on "liveChat.cannedResponses.saveButton"

    When Intercept "GET: ${DRUPAL_URL}jsonapi/node/canned_response*" as "searchRequest"
    And Type "CannedResponse${randomNumber}{enter}" in "liveChat.cannedResponses.searchInput"
    And Wait for "searchRequest" network call
    And Tag "p" with text "CannedResponse${randomNumber}" should "exist"

    And Click on "liveChat.cannedResponses.firstCannedResponseItem"
    And Click on "liveChat.cannedResponses.deleteButton"
    And Click on "liveChat.cannedResponses.confirmDelete"
    And Element "liveChat.cannedResponses.successDeletionNotification" should "exist"

    Then  Type "CannedResponse${randomNumber}{enter}" in "liveChat.cannedResponses.searchInput"
    And Wait for "searchRequest" network call
    And Element "div.MuiButtonBase-root.MuiAccordionSummary-root" should "not.exist"
    And Tag "p" with text "CannedResponse${randomNumber}" should "not.exist"

  Scenario: Editing Canned Response
    Given Login as "defaultUser"
    When Open chatbot "chatbotForAutomation"

    When Open "Live Chat->Canned Responses" menu item
    Then Verify that selector "liveChat.cannedResponses.cannedResponseCount" contains more than "1" elements
    And Click on "liveChat.cannedResponses.firstCannedResponseItem"
    And Click on "liveChat.cannedResponses.editButton"
    And Create random number and save it as "id"
    And Type "EditedCannedTitle${id}" in "liveChat.cannedResponses.editTitle"
    And Type "EditedCannedResponse${id}" in "liveChat.cannedResponses.editResponse"
    And Click on "liveChat.cannedResponses.saveButton"
    Then Type "EditedCannedTitle${id}" in "liveChat.cannedResponses.searchInput"
    When Intercept "GET: ${DRUPAL_URL}jsonapi/node/canned_response*" as "searchRequest"
    And Type "EditedCannedTitle${id}{enter}" in "liveChat.cannedResponses.searchInput"
    And Wait for "searchRequest" network call
    Then Verify that selector "liveChat.cannedResponses.cannedResponseCount" contains "1" elements
    And Click on "liveChat.cannedResponses.firstCannedResponseItem"
    And Tag "p" with text "EditedCannedTitle${id}" should "exist"
    And Tag "p" with text "EditedCannedResponse${id}" should "exist"
