Feature: Permissions - question templates

  Scenario: Viewing Question Templates
    Given Login using random user from the list
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Question Templates" menu item
    And Click on "chatbot.knowledgebase.generalLibrary.viewFirstQuestion"
    Then Element "div.Mui-expanded>div.MuiCollapse-entered" should "exist"
