Feature: Campaigns - provision numbers

  Scenario: Viewing and Exporting provision numbers
    Given Login using random user from the list
      | viewOtherOfficesCampaigns |
      | campaignsStandard         |
      | campaignsAdmin            |
    And Open chatbot "chatbotForAutomation"
    When Open "Texting->Phone Numbers" menu item
    Then Verify that element "texting.phoneNumbers.phoneNumberFromFirstRow" has phone number

    When Intercept "${MESSAGE_API_DOMAIN}phone-numbers/exported*" as "downloadRequest"
    And Add reload event listener
    And  Click on "texting.phoneNumbers.exportResults"
    And Wait for "downloadRequest" network call
    Then Verify that download folder contains "phone-numbers.csv"

  Scenario: Unsolicited Message Settings - bot response
    Given Login as "campaignsAdmin"
    And Open chatbot "chatbotForAutomation"
    And Open "Texting->Phone Numbers" menu item
    And Save "(513) 548-3310" as "studentNumber"
    And Create random number and save it as "id"
    And Create provision number
      | name                  | ProvisionNumber${id}                                     |
      | description           | [Automation]:Unsolicited Message Settings - bot response |
      | areaCode              | 660                                                      |
      | office                | MyCampus - Office 1                                      |
      | responseType          | Bot                                                      |
      | saveProvisionNumberAs | provisionNumber                                          |
      | inbox                 | CampaignsAdmin Automation                                |

    When Send SMS "What is your name?" to "${provisionNumber}" from "${studentNumber}"
    And Delete provision number "${provisionNumber}"
    Then Verify that "${studentNumber}" number "received" "${chatbotNameResponse}" message

    When Open chatbot "chatbotForAutomation"
    And Open "Texting->Transcripts" menu item
    And Intercept "${GRAPHQL_URL}graphql" with "getCampaignTranscriptList" keyword in the response as "searchRequest"
    And Type "What is your name?" in "texting.transcripts.searchInput"
    And Wait for "searchRequest" network call
    And Click on "texting.transcripts.viewConversationFirstRow"
    And Click on tag "h6" which contains text "Conversation Details"
    And Save current date as "date" using "yyyy-mm-dd" format
    Then Tag "div>span" with text "${chatbotNameResponse}" should "exist"
    And Tag "#conversation-details-pane div" with text "${date}" should "exist"
    And Tag "#conversation-details-pane div" with text "${provisionNumber}" should "exist"
    And Tag "#conversation-details-pane div" with text "${studentNumber}" should "exist"

  Scenario: Unsolicited Message Settings - agent response
  Test creates provision number with agent response mode. Then it send message to this number and checks Inbox and
  conversation details. Also it replies to this number.
    Given Login as "campaignsAdmin"
    And Open chatbot "chatbotForAutomation"
    And Open "Texting->Phone Numbers" menu item
    And Save "(513) 548-3310" as "studentNumber"
    And Create random number and save it as "id"
    And Create provision number
      | name                  | ProvisionNumber${id}                                     |
      | description           | [Automation]:Unsolicited Message Settings - bot response |
      | areaCode              | 660                                                      |
      | office                | MyCampus - Office 1                                      |
      | responseType          | Agent                                                    |
      | saveProvisionNumberAs | provisionNumber                                          |
      | inbox                 | CampaignsAdmin Automation                                |

    When Send SMS "Hey Agent ${id}" to "${provisionNumber}" from "${studentNumber}"
    Then Tag "#notistack-snackbar" with text "Inbox needs attention" should "exist"

    When Click on tag "span.MuiButton-label" which contains text "View"
    And Intercept "${GRAPHQL_URL}graphql" with "inboxFilterConversations" keyword in the response as "searchRequest"
    And Type "Hey Agent ${id}" in "inbox.searchInput"
    And Wait for "searchRequest" network call
    And Click on tag "p" which contains text "Hey Agent ${id}"
    Then Tag "div" with text "Hey Agent ${id}" should "exist"

    When Type "Agent is here ${id}" in "inbox.messageInput"
    And Wait "1000"
    And Click on "inbox.sendButton"
    Then Verify that "${studentNumber}" number "received" "Agent is here ${id}" message

    When Click on tag "h6" which contains text "Conversation Details"
    And Save current date as "date" using "yyyy-mm-dd" format
    Then Tag "div" with text "${provisionNumber}" should "exist"
    And Tag "div" with text "${studentNumber}" should "exist"
    And Tag "div" with text "${date}" should "exist"

    And Open "Texting->Phone Numbers" menu item
    And Delete provision number "${provisionNumber}"
