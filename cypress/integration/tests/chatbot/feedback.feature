Feature: Permissions - chatbot feedback

  Scenario: Viewing and Exporting Chatbot Feedback
  Test sends feedback via API and verifies that feedback message is present on the Feedback page. After it
  test downloads feedback and checks that exported file contains unique keyword.
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

    When Add reload event listener
    And Click on "chatbot.transcripts.exportTranscripts"
    Then Verify that download folder contains "feedback-"
    And Get full file name with prefix "feedback-" in download folder and save it as "feedbackFile"
    And Verify that file "${feedbackFile}" from download folder contains text "Feedback ${randomNumber}"

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
    Then Tag "li>a" with text "Feedback" should "not.exist"
