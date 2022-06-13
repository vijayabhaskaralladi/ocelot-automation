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

  Scenario Outline: TMD-43: Verify that user <user_name> can't view Transcripts of other users
    Given Login as "<user_name>"
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat->Transcripts" menu item
    And URL should include "transcripts"
    And Add '?startDate=2022-02-07' to the current URL
    Then Tag "th.MuiTableCell-root" with text "Hi Office 1" should "not.exist"
    Examples:
      | user_name        |
      | liveChatStandard |

  Scenario Outline: TMD-51: Verify that user <user_name> can't view any Transcript
    Given Login as "<user_name>"
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat" menu item
    Then Tag "span.MuiButton-label" with text "Transcripts" should "not.exist"
    Examples:
      | user_name       |
      | liveChatLimited |
