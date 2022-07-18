Feature: Permissions - custom questions

  Scenario: Exporting Chatbot Transcripts
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

  Scenario: Viewing Custom Questions
    Given Login using random user from the list
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Custom Questions" menu item
    Then Verify that page title is "Custom Questions"
    And Verify that selector "chatbot.knowledgebase.customQuestions.questions" contains more than "2" elements

    When Click on "chatbot.knowledgebase.customQuestions.viewFirstQuestion"
    Then Element "div.Mui-expanded>div.MuiCollapse-entered" should "exist"
