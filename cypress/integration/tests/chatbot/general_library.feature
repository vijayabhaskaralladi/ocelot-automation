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
