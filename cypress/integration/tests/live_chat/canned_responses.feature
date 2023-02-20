Feature: Permissions - Canned responses

  Scenario: Canned responses - sorting
    Given Login using random user from the list
      | liveChatLimited          |
      | liveChatStandard         |
      | liveChatAdmin            |
      | viewOtherOfficesLiveChat |
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat->Canned Responses" menu item
    Then Verify that page title is "Canned Responses"
    And Click on "liveChat.cannedResponses.buttonSort"
    And Intercept "${DRUPAL_URL}jsonapi/node/canned_response?filter*" as "sortCannedResponses"
    And Click on tag "li" which contains text "Title, Z-A"
    And Wait for "sortCannedResponses" and save it as "sortCannedResponsesresponse"

    Then Verify that response "sortCannedResponsesresponse" has status code "200"
    And Tag "span" with text "Sort: Title, Z-A" should "exist"
    And Verify that element "liveChat.cannedResponses.firstCannedResponseItem" has the following text "${lastCannedResponse}"
    And Verify that selector "liveChat.cannedResponses.questions" contains more than "5" elements

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
    And Click on tag "span.MuiTypography-body1.MuiListItemText-primary" which contains text "All Campuses/Offices"
    And Click on "liveChat.cannedResponses.saveButton"

    Then Type "CannedResponse${randomNumber}{enter}" in "liveChat.cannedResponses.searchInput"
    And Tag "p" with text "CannedResponse${randomNumber}" should "exist"

  @low_priority
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
    And Click on tag "span.MuiTypography-body1.MuiListItemText-primary" which contains text "All Campuses/Offices"
    And Click on "liveChat.cannedResponses.saveButton"

    When Intercept "GET: ${DRUPAL_URL}jsonapi/node/canned_response*" as "searchRequest"
    And Find "CannedResponse${randomNumber}"
    And Wait for "searchRequest" network call
    And Tag "p" with text "CannedResponse${randomNumber}" should "exist"

    And Click on "liveChat.cannedResponses.firstCannedResponseItem"
    And Click on "liveChat.cannedResponses.deleteButton"
    And Click on "liveChat.cannedResponses.confirmDelete"
    And Element "liveChat.cannedResponses.successDeletionNotification" should "exist"

    And Find "CannedResponse${randomNumber}"
    And Wait for "searchRequest" network call
    And Element "div.MuiButtonBase-root.MuiAccordionSummary-root" should "not.exist"
    And Tag "p" with text "CannedResponse${randomNumber}" should "not.exist"

  @do_not_run_on_com
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
    Then Verify that selector "liveChat.cannedResponses.cannedResponseCount" contains more than "5" elements
    When Intercept "GET: ${DRUPAL_URL}jsonapi/node/canned_response?filter*" as "searchRequest"
    And Type "EditedCannedTitle${id}{enter}" in "liveChat.cannedResponses.searchInput"
    And Wait for "searchRequest" network call
    And Verify that page contains text "1–1 of 1"
    And Click on "liveChat.cannedResponses.firstCannedResponseItem"
    And Tag "p" with text "EditedCannedTitle${id}" should "exist"
    And Tag "p" with text "EditedCannedResponse${id}" should "exist"
