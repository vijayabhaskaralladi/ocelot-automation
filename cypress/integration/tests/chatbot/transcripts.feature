Feature: Permissions - chatbot transcripts

  Scenario: Chatbot transcripts - filtering
  This test filters transcripts
    Given Login as "chatbotAdmin"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Transcripts" menu item
    And Choose random value from "Yes|No" and save it as "isInquiryForm"
    And Choose random value from "Read|Unread" and save it as "readStatus"
    And Choose random value from "MyCampus - Office 1|MyCampus - Office 2" and save it as "office"

    When Intercept "POST: ${MESSAGE_API_DOMAIN}api/legacy/stats/conversations" as "markConversationNetworkCall"
    And Click on "chatbot.transcripts.filter"
    And Wait for element "chatbot.transcripts.labelOffice"
    And Click on "chatbot.transcripts.officeStatus"
    And Click on tag "li" which contains text "${office}"
    And Wait for "markConversationNetworkCall" and save it as "markConversationResponse"
    Then Verify that response "markConversationResponse" has status code "200"
    And Verify that selector "chatbot.transcripts.rowSelector" contains more than "1" elements

    When Click on "chatbot.transcripts.filter"
    And Wait for element "chatbot.transcripts.labelReadStatus"
    And Click on "chatbot.transcripts.readStatus"
    And Click on tag "li" which contains text "${readStatus}"
    And Wait for "markConversationNetworkCall" and save it as "markConversationResponse"
    Then Verify that response "markConversationResponse" has status code "200"

    When Click on "chatbot.transcripts.filter"
    And Wait for element "chatbot.transcripts.labelInquiryFormStatus"
    And Click on "chatbot.transcripts.inquiryFormStatus"
    And Click on tag "li" which contains text "${isInquiryForm}"
    Then Wait for "markConversationNetworkCall" and save it as "markConversationResponse"
    And Verify that response "markConversationResponse" has status code "200"

    And Tag "span.MuiChip-label" with text "Inquiry Form: ${isInquiryForm}" should "exist"
    And Tag "span.MuiChip-label" with text "Read Status: ${readStatus}" should "exist"
    And Tag "span.MuiChip-label" with text "Office: ${office}" should "exist"

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
    Validate date and other parameters on Conversation page of transcripts
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
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Transcripts" menu item
    And Click on "chatbot.transcripts.viewConversationFirstRow"
    And Click on tag "h6" which contains text "Conversation Details"
    Then Verify that page contains text "HeyHey${id}"
    Then Save current date as "date" using "yyyy-mm-dd" format
    Then Tag ".Mui-expanded div" with text "${date}" should "exist"

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