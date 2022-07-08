Feature: Chatbot - inquiry form

  Scenario: Enabled Inquiry Form should send emails with lead data
  Test expects that we added 'automation@dqwhivf6.mailosaur.net' address to 'Email Destinations' manually
    Given Login as "defaultUser"
    And Open chatbot "chatbotForInquiryForm"
    And Open "Chatbot->Behavior Settings" menu item
    And Enable Inquiry Form
      | name        | checked |
      | email       | checked |
      | phone       | checked |
      | Immediately | checked |

    And Remove incoming messages from automation inbox
    And Create random number and save it as "id"
    And API: Select "chatbotForInquiryForm" chatbot

    When API: Send first message "Answer Question(s)" and save response as "firstResponse"
    And Retrieve "body.context.conversation_id" from "firstResponse" and save as "conversationId"
    And API: Send message "Automation Buddy${id}" for "conversationId" conversation
    And API: Send message "student${id}@automation.com" for "conversationId" conversation
    And API: Send message "111-222-${id}" for "conversationId" conversation

    Then Extract link from email with subject "New Lead Data from Chatbot" and save as "leadDataLink"
    And Visit "${leadDataLink}"

    And Tag "div" with text "Automation Buddy${id}" should "exist"
    And Tag "div" with text "student${id}@automation.com" should "exist"
    And Tag "div" with text "111-222-${id}" should "exist"