Feature: Permissions - chatbot feedback

  Scenario: Viewing Chatbot Feedback
    Given Login using random user from the list
      | viewOtherOfficesChatbot |
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Feedback" menu item
    Then Verify that element "chatbot.feedback.netPromoterScoreValue" contains positive number

  Scenario: Limited users can't see Chatbot Feedback
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
    Then Tag "span.MuiButton-label" with text "Feedback" should "not.exist"
