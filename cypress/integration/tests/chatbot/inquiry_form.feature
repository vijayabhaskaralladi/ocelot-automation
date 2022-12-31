Feature: Chatbot - inquiry form

  Scenario: Enabled Inquiry Form should send emails with lead data
  Test expects that we added 'automation@dqwhivf6.mailosaur.net' address to 'Email Destinations' manually
    Given Login as "defaultUser"
    And Open chatbot "chatbotForInquiryForm"
    And Open "Chatbot->Behavior Settings" menu item
    And Create random number and save it as "id"
    # temporary workaround for MAINT-1855
    And Wait "3000"
    And Enable Inquiry Form
      | message     | Inquiry test ${id} |
      | name        | checked            |
      | email       | checked            |
      | phone       | checked            |
      | Immediately | checked            |

    And Remove incoming messages from automation inbox
    And API: Select "chatbotForInquiryForm" chatbot
    And API: Check that chatbot welcome message is "Inquiry test ${id}"
    When API: Send first message "Answer Question(s)" and save response as "firstResponse"
    And Retrieve "body.context.conversation_id" from "firstResponse" and save as "conversationId"
    And API: Send message
      | message             | Automation Buddy${id} |
      | conversationIdAlias | conversationId        |
    And API: Send message
      | message             | student${id}@automation.com |
      | conversationIdAlias | conversationId              |
    And API: Send message
      | message             | 111-222-${id}  |
      | conversationIdAlias | conversationId |

    Then Extract link from email with subject "New Lead Data from Chatbot" and save as "leadDataLink"
    And Visit "${leadDataLink}"
    And Click on "chatbot.transcripts.viewConversationFirstRow"
    And Tag "div" with text "Inquiry test ${id}" should "exist"
    And Tag "div" with text "Automation Buddy${id}" should "exist"
    And Tag "div" with text "student${id}@automation.com" should "exist"
    And Tag "div" with text "111-222-${id}" should "exist"
