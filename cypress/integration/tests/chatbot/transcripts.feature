Feature: Permissions - chatbot transcripts

  Scenario: Exporting Chatbot Transcripts
    Given API: Select "chatbotForAutomation" chatbot
    And Create random number and save it as "id"
    And API: Create dialog and save conversation_id as "conversationId"
    And API: Send message
      | message             | HeyHey${id}    |
      | conversationIdAlias | conversationId |

    And Login using random user from the list
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
      | defaultUser             |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Transcripts" menu item
    And Add reload event listener
    And Click on "chatbot.transcripts.exportTranscripts"
    Then Verify that download folder contains "conversations-"
    And Get full file name with prefix "conversations-" in download folder and save it as "transcriptsFile"
    And Verify that file "${transcriptsFile}" from download folder contains text "HeyHey${id}"

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
    And API: Send message
      | message             | What is FAFSA? |
      | conversationIdAlias | conversationId |

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
    And API: Send message
      | message             | Financial Aid OFFICE |
      | conversationIdAlias | conversationId       |
    And API: Send message
      | message             | how are you?   |
      | conversationIdAlias | conversationId |
    And API: Send message
      | message             | what is your name? |
      | conversationIdAlias | conversationId     |
    And Login as "defaultUser"

    When Open chatbot "aimsCommunityCollege"
    And Open 'Chatbot->Transcripts' menu item
    And Open the latest transcript
    Then Verify that page contains text "how are you?"
    And Verify that page contains text "what is your name?"

  Scenario: Creating conversations with different offices
  Test creates 2 conversations - with office 1 and office 2. Then it verifies transcripts and filtering by office.
    Given API: Select "chatbotForAutomation" chatbot

    And Create random number and save it as "id"
    And API: Send first message to specific Office
      | message             | Hi Office 1 ${id}                |
      | officeId            | ${chatbotForAutomationOffice1Id} |
      | campusId            | ${chatbotForAutomationCampusId}  |
      | saveResponseAs      | response1                        |

    And API: Send first message to specific Office
      | message           | Hi Office 2 ${id}                |
      | officeId          | ${chatbotForAutomationOffice2Id} |
      | campusId          | ${chatbotForAutomationCampusId}  |
      | saveResponseAs    | response2                        |

    When Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Transcripts" menu item
    And Click on "chatbot.transcripts.filter"
    And Click on "chatbot.transcripts.officeDropdown"
    And Click on tag "li" which contains text "MyCampus - Office 1"

    Then Tag "th" with text "Hi Office 1 ${id}" should "exist"
    And Tag "th" with text "Hi Office 2 ${id}" should "not.exist"