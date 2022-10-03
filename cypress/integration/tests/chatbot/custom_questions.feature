Feature: Permissions - custom questions

  Scenario: Exporting Custom Questions
    Given Login using random user from the list
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
      | defaultUser             |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Add reload event listener
    And Click on "chatbot.knowledgebase.customQuestions.exportCustomQuestions"
    Then Verify that download folder contains "review-custom"
    And Get full file name with prefix "review-custom" in download folder and save it as "customQuestionsFile"
    And Verify that file "${customQuestionsFile}" from download folder contains text "Custom question for automation"

  Scenario: TMD-44: User should see custom questions from library assigned to his office
  User from Office 1(financial aid lib) should see custom questions from Financial Aid library
    Given Login as "chatbotStandard-FinancialAidOffice"
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Type "${financialAidLibraryCustomQuestion}" in "chatbot.knowledgebase.customQuestions.search"
    Then Tag "p.MuiTypography-body1" with text "${financialAidLibraryCustomQuestion}" should "exist"

  Scenario: TMD-44: User shouldn't see custom questions from other libraries
  User from Office 1(financial aid lib) shouldn't see custom questions from Bookstore library
    Given Login as "chatbotStandard-FinancialAidOffice"
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Type "${bookstoreLibraryCustomQuestion}" in "chatbot.knowledgebase.customQuestions.search"
    And Wait "5000"
    Then Tag "p" with text "${bookstoreLibraryCustomQuestion}" should "not.exist"

  Scenario: TMD-44: User should see custom questions from other offices if offices have the same libraries
  User from Office 3(financial aid lib) should see custom questions from Office 1(financial aid lib + athletics lib)
    Given Login as "chatbotStandard-AthleticsOffice"
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Type "${financialAidLibraryCustomQuestion}" in "chatbot.knowledgebase.customQuestions.search"
    And Wait "5000"
    Then Tag "p" with text "${financialAidLibraryCustomQuestion}" should "exist"

  Scenario: Viewing Custom Questions and Filtering by Financial Aid and Locked Content
    Given Login using random user from the list
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Custom Questions" menu item
    Then Verify that page title is "Custom Questions"
    And Verify that selector "chatbot.knowledgebase.customQuestions.questions" contains more than "2" elements
    And Intercept "${DRUPAL_URL}jsonapi/chatbot_question/chatbot_question*" as "searchRequest"
    And Click on "chatbot.knowledgebase.customQuestions.filterResults"
    And Click on "chatbot.knowledgebase.customQuestions.departmentFilter"
    And Click on "chatbot.knowledgebase.customQuestions.financialAidFilterValue"
    And Wait for "searchRequest" network call
    Then Verify that element "chatbot.knowledgebase.customQuestions.departmentFilterName" has the following text "Department: Financial Aid"
    Then Verify that selector "chatbot.knowledgebase.customQuestions.customQuestionListTable" contains more than "1" elements
    And Scroll to "chatbot.knowledgebase.customQuestions.removeFilter" element
    And Click on "chatbot.knowledgebase.customQuestions.removeFilter"
    And Click on "chatbot.knowledgebase.customQuestions.lockedContentFilter"
    And Click on "chatbot.knowledgebase.customQuestions.lockedFilterValue"
    And Wait for "searchRequest" network call
    Then Verify that element "chatbot.knowledgebase.customQuestions.lockedFilterName" has the following text "Locked Content: Locked"
    Then Verify that selector "chatbot.knowledgebase.customQuestions.customQuestionListTable" contains more than "1" elements
    And Scroll to "chatbot.knowledgebase.customQuestions.removeFilter" element
    And Click on "chatbot.knowledgebase.customQuestions.removeFilter"
    When Click on "chatbot.knowledgebase.customQuestions.viewFirstQuestion"
    Then Element "div.Mui-expanded>div.MuiCollapse-entered" should "exist"

  Scenario: Editing Custom Question
    Given Login using random user from the list
      | chatbotStandard |
      | chatbotAdmin    |
    And Open chatbot "chatbotForAutomation"
    And Create random number and save it as "id"
    And Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Verify that page title is "Custom Questions"
    When Type "${customQuestionForEditing}" in "chatbot.knowledgebase.customQuestions.search"
    And Verify that selector "chatbot.knowledgebase.customQuestions.questions" contains "1" elements
    And Click on "chatbot.knowledgebase.customQuestions.viewFirstQuestion"
    And Click on tag "span" which contains text "Edit"
    And Scroll to "chatbot.knowledgebase.customQuestions.editResponseField" element
    And Type "Updated response ${id}" in "chatbot.knowledgebase.customQuestions.editResponseField"
    And Click on tag "button" which contains text "Save"
    Then Tag "#notistack-snackbar" with text "Your question has been successfully published and will soon become part of the bot's knowledgebase!" should "exist"
    And Tag "div[role='region']>div.MuiAccordionDetails-root" with text "Updated response ${id}" should "exist"
    And Tag "span.MuiChip-label" with text "new" should "exist"