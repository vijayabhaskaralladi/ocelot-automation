Feature: Permissions - general library

  Scenario: General Library - sorting
    Given Login using random user from the list
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->General Library" menu item
    Then Verify that page title is "General Library"
    And Click on "common.questions.sortResults"
    And Intercept "${DRUPAL_URL}jsonapi/chatbot_question/chatbot_question?filter*" as "sortGeneralLibrary"
    And Click on tag "li" which contains text "Title, Z-A"
    And Wait for "sortGeneralLibrary" and save it as "sortGeneralLibraryResponse"

    Then Verify that response "sortGeneralLibraryResponse" has status code "200"
    And Tag "span" with text "Sort: Title, Z-A" should "exist"
    And Verify that element "chatbot.knowledgebase.generalLibrary.firstQuestion" has the following text "${lastGeneralQuestion}"
    And Verify that selector "chatbot.knowledgebase.generalLibrary.questions" contains more than "5" elements

  Scenario: Viewing General Library
    Given Login using random user from the list
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"

    When Open "Chatbot->Knowledgebase->General Library" menu item
    Then Verify that page title is "General Library"
    And Verify that selector "chatbot.knowledgebase.generalLibrary.questions" contains more than "2" elements
    And Intercept "${DRUPAL_URL}jsonapi/chatbot_question/chatbot_question?filter*" as "filterGeneralLibrary"
    And Click on "chatbot.knowledgebase.generalLibrary.filterButton"
    And Click on "chatbot.knowledgebase.generalLibrary.departmentFilter"
    And Click on "chatbot.knowledgebase.generalLibrary.admissionFilter"
    And Wait for "filterGeneralLibrary" network call
    Then Verify that page contains element "chatbot.knowledgebase.generalLibrary.filterValue" with text "Department: Admissions"
    And Verify that selector "chatbot.knowledgebase.generalLibrary.questions" contains more than "1" elements
    And Click on "chatbot.knowledgebase.generalLibrary.deleteFilter"
    And Wait for "filterGeneralLibrary" network call
    And Verify that selector "chatbot.knowledgebase.generalLibrary.questions" contains more than "1" elements
    When Click on "chatbot.knowledgebase.generalLibrary.viewFirstQuestion"
    Then Element "div.Mui-expanded>div.MuiCollapse-entered" should "exist"

  Scenario: Limited users can't view General Library
  Test verifies that specified users don't see 'Knowledgebase' item in the menu
    Given Login using random user from the list
      | viewOtherOfficesLiveChat  |
      | viewOtherOfficesCampaigns |
      | liveChatLimited           |
      | liveChatStandard          |
      | liveChatAdmin             |
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot" menu item
    Then Tag "li>button" with text "Knowledgebase" should "not.exist"

  Scenario: Verify that User having access to Bookstore Library cannot view FinancialAid library question
    Given Login as "chatbotStandard-BookstoreOffice"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Knowledgebase->General Library" menu item
    When Type "${bookstoreLibraryGeneralQuestion}" in "common.questions.searchQuestion"
    Then Verify that selector "chatbot.knowledgebase.generalLibrary.questions" contains "1" elements
    When Type "${financialAidLibraryGeneralQuestion}" in "common.questions.searchQuestion"
    Then Verify that selector "chatbot.knowledgebase.generalLibrary.questions" contains "0" elements