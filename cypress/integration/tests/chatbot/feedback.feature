Feature: Permissions - chatbot feedback

  Scenario: Viewing Chatbot Feedback
    Given API: Select "chatbotForAutomation" chatbot
    And API: Create dialog and save conversation_id as "conversationId"
    And Create random number and save it as "randomNumber"
    And API: Send feedback
      | conversationId  | ${conversationId}        |
      | score           | 7                        |
      | feedbackMessage | Feedback ${randomNumber} |

    When Login using random user from the list
      | viewOtherOfficesChatbot |
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Feedback" menu item

    Then Verify that element "chatbot.feedback.netPromoterScoreValue" contains positive number
    And Tag "th" with text "Feedback ${randomNumber}" should "exist"

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
