Feature: Permissions - general library

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
    Then Tag "span.MuiButton-label" with text "Knowledgebase" should "not.exist"

  Scenario: Verify that User having access to Bookstore Library cannot view FinancialAid library question
    Given Login as "chatbotStandard-BookstoreOffice"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Knowledgebase->General Library" menu item
    When Type "${bookstoreLibraryGeneralQuestion}" in "chatbot.knowledgebase.generalLibrary.search"
    Then Verify that selector "chatbot.knowledgebase.generalLibrary.questions" contains "1" elements
    When Type "${financialAidLibraryGeneralQuestion}" in "chatbot.knowledgebase.generalLibrary.search"
    Then Verify that selector "chatbot.knowledgebase.generalLibrary.questions" contains "0" elements