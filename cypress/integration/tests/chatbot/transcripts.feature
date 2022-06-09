Feature: Permissions - chatbot transcripts

  Scenario: TMD-28: Viewing Chatbot Transcripts
    Given Login using random user from the list
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Transcripts" menu item
    And Click on "chatbot.transcripts.viewConversationFirstRow"
    Then Tag "h6" with text "Conversation Details" should "exist"

  Scenario: TMD-28: Limited users can't View Chatbot Transcripts
    Given Login using random user from the list
      | viewOtherOfficesLiveChat  |
      | viewOtherOfficesCampaigns |
      | chatbotLimited            |
      | liveChatLimited           |
      | liveChatStandard          |
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot" menu item
    Then Tag "span.MuiButton-label" with text "Transcripts" should "not.exist"

  Scenario: TMD-29: Marking transcript as Read/Unread
  This test creates conversation and verifies that specified users can mark this transcript as Read/Unread
    Given API: Select "chatbotForAutomation" chatbot
    And API: Create dialog and save conversation_id as "conversationId"
    And API: Send message "What is FAFSA?" for "conversationId" conversation

    And Login using random user from the list
      | chatbotStandard |
      | chatbotAdmin    |
    And Open chatbot "chatbotForAutomation"

    When Open "Chatbot->Transcripts" menu item
    And Intercept "POST: ${MESSAGE_API_DOMAIN}api/legacy/conversation/read" as "markReadNetworkCall"
    And Click on "chatbot.transcripts.markReadFirstRow"
    And Wait for "markReadNetworkCall" and save it as "markReadResponse"
    And Verify that response "markReadResponse" has status code "204"

    When Intercept "POST: ${MESSAGE_API_DOMAIN}api/legacy/conversation/unread" as "markUnreadNetworkCall"
    And Click on "chatbot.transcripts.markUnreadFirstRow"
    And Wait for "markUnreadNetworkCall" and save it as "markUnreadResponse"
    And Verify that response "markUnreadResponse" has status code "204"

  Scenario: TMD-15: Create dialog and verify transcript
    Given API: Select "aimsCommunityCollege" chatbot
    And API: Create dialog and save conversation_id as "conversationId"
    And API: Send message "Financial Aid OFFICE" for "conversationId" conversation
    And API: Send message "how are you?" for "conversationId" conversation
    And API: Send message "what is your name?" for "conversationId" conversation
    And Client Admin test setup
      | chatbotStandard  |
      | chatbotAdmin     |
      | liveChatStandard |
      | liveChatAdmin    |

    When Open chatbot "aimsCommunityCollege"
    And Open 'Chatbot->Transcripts' menu item
    And Open the latest transcript
    Then Verify that page contains text "how are you?"
    And Verify that page contains text "what is your name?"
