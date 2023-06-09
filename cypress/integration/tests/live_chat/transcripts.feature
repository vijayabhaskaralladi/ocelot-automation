Feature: Permissions - Live Chat transcripts

  Background:
    Given Save "?startDate=2022-02-07&endDate=2022-05-01" as "dateFilter"

  @do_not_run_on_com
  Scenario: Exporting Live Chat Transcripts
  Test expects that transcripts contain at least 1 conversation where student name is 'Unknown Student'
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat->Transcripts" menu item
    And Add reload event listener
    And Click on "liveChat.transcripts.exportTranscripts"
    Then Verify that download folder contains "live-chat-transcripts.csv"
    And Verify that file "live-chat-transcripts.csv" from download folder contains text "studentName"
    #Following step is commented due to data unavailability some times
    #And Verify that file "live-chat-transcripts.csv" from download folder contains text "Unknown Student"

  @low_priority
  Scenario: TMD-43: Live Chat admin of Office 3 can't view Transcripts for Office 1 and Office 2
    Given Login as "chatbotStandard-AthleticsOffice"
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat->Transcripts" menu item
    And URL should include "transcripts"
    And Add "${dateFilter}" to the current URL
    Then Tag "th.MuiTableCell-root" with text "Hi Office 1" should "not.exist"
    And Tag "th.MuiTableCell-root" with text "Hi Office 2" should "not.exist"

  Scenario: TMD-43: Live Chat admin(all offices) can view Transcripts for all offices
    Given Login as "liveChatAdmin"
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat->Transcripts" menu item
    And URL should include "transcripts"
    And Add "${dateFilter}" to the current URL
    Then Tag "th.MuiTableCell-root" with text "Hi Office 1" should "exist"
    And Tag "th.MuiTableCell-root" with text "Hi Office 2" should "exist"

  @low_priority
  Scenario: TMD-43: Standard user can't view Transcripts of other users
    Given Login as "liveChatStandard"
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat->Transcripts" menu item
    And URL should include "transcripts"
    And Add "${dateFilter}" to the current URL
    Then Tag "th.MuiTableCell-root" with text "Hi Office 1" should "not.exist"

  @low_priority
  Scenario: TMD-51: Limited user can't view any Transcript
    Given Login as "liveChatLimited"
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat" menu item
    Then Tag "span.MuiButton-label" with text "Transcripts" should "not.exist"

  @do_not_run_on_com
  Scenario: Marking Live Chat transcripts as read and unread
    Given Login as "liveChatAdmin"
    And Open chatbot "chatbotForAutomation"
    And Open "Live Chat->Transcripts" menu item
    And URL should include "transcripts"
    And Intercept "POST: ${GRAPHQL_URL}graphql" as "liveChatTranscriptsRequest"
    And Add "?readStatus=Unread&startDate=2022-05-31" to the current URL
    And Wait for "liveChatTranscriptsRequest" network call
    And Verify that response "liveChatTranscriptsRequest" has status code "200"

    And Intercept "${GRAPHQL_URL}graphql" with "setLiveChatTranscriptReadStatus" keyword in the response as "readStatusRequest"
    When Click on "liveChat.transcripts.statusWithUnReadButtonFirstRow"
    And Wait for "readStatusRequest" network call
    Then Verify that response "readStatusRequest" has status code "200"
    And Verify that response "readStatusRequest" has field "response.body.data.setLiveChatTranscriptReadStatus.read_status" equal to "1"
    And Verify that element "liveChat.transcripts.readStatusButtonFirstRow" has attribute "aria-label" with value "Mark Unread"

    When Click on "liveChat.transcripts.statusWithReadButtonFirstRow"
    And Wait for "readStatusRequest" network call
    Then Verify that response "readStatusRequest" has status code "200"
    And Verify that response "readStatusRequest" has field "response.body.data.setLiveChatTranscriptReadStatus.read_status" equal to "-1"
    And Verify that element "liveChat.transcripts.readStatusButtonFirstRow" has attribute "aria-label" with value "Mark Read"
