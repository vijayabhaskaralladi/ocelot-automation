Feature: Permissions - Live Chat transcripts

  Scenario: TMD-43: Live Chat admin of Office 3 can't view Transcripts for Office 1 and Office 2
    Given Login as "chatbotStandard-AthleticsOffice"
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat->Transcripts" menu item
    And URL should include "transcripts"
    And Add '?startDate=2022-02-07' to the current URL
    Then Tag "th.MuiTableCell-root" with text "Hi Office 1" should "not.exist"
    And Tag "th.MuiTableCell-root" with text "Hi Office 2" should "not.exist"

  Scenario: TMD-43: Live Chat admin(all offices) can view Transcripts for all offices
    Given Login as "liveChatAdmin"
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat->Transcripts" menu item
    And URL should include "transcripts"
    And Add '?startDate=2022-02-07' to the current URL
    Then Tag "th.MuiTableCell-root" with text "Hi Office 1" should "exist"
    And Tag "th.MuiTableCell-root" with text "Hi Office 2" should "exist"

  Scenario: TMD-43: Standard user can't view Transcripts of other users
    Given Login as "liveChatStandard"
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat->Transcripts" menu item
    And URL should include "transcripts"
    And Add '?startDate=2022-02-07' to the current URL
    Then Tag "th.MuiTableCell-root" with text "Hi Office 1" should "not.exist"

  Scenario: TMD-51: Limited user can't view any Transcript
    Given Login as "liveChatLimited"
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat" menu item
    Then Tag "span.MuiButton-label" with text "Transcripts" should "not.exist"

  Scenario: Marking Live Chat transcripts as read and unread
    Given Login as "liveChatAdmin"
    And Open chatbot "chatbotForAutomation"
    And Open "Live Chat->Transcripts" menu item
    And URL should include "transcripts"
    And Add "?startDate=2021-07-25&readStatus=Read" to the current URL
    And Intercept "${GRAPHQL_URL}graphql" with "setLiveChatTranscriptReadStatus" keyword in the response as "readStatusRequest"

    When Click on "liveChat.transcripts.readStatusButtonFirstRow"
    And Wait for "readStatusRequest" network call
    Then Verify that response "readStatusRequest" has status code "200"
    And Verify that response "readStatusRequest" has field "response.body.data.setLiveChatTranscriptReadStatus.read_status" equal to "-1"
    And Verify that element "liveChat.transcripts.readStatusButtonFirstRow" has attribute "aria-label" with value "Mark Read"

    When Click on "liveChat.transcripts.readStatusButtonFirstRow"
    And Wait for "readStatusRequest" network call
    Then Verify that response "readStatusRequest" has status code "200"
    And Verify that response "readStatusRequest" has field "response.body.data.setLiveChatTranscriptReadStatus.read_status" equal to "1"
    And Verify that element "liveChat.transcripts.readStatusButtonFirstRow" has attribute "aria-label" with value "Mark Unread"
