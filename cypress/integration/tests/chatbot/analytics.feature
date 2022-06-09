Feature: Permissions - chatbot analytics

  Scenario: TMD-13: Viewing Chatbot Analytics
    Given Login using random user from the list
      | viewOtherOfficesChatbot |
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Analytics" menu item
    Then Verify that element "chatbot.analytics.conversationsNumber" contains positive number
    And Verify that element "chatbot.analytics.interactionsNumber" contains positive number

  Scenario: Limited users can't view Chatbot Analytics
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
    And Open "Chatbot" menu item
    Then Tag "span.MuiButton-label" with text "Analytics" should "not.exist"
