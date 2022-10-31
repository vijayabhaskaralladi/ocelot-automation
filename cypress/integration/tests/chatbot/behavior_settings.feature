Feature: Behavior Settings
  Scenario: Behavior Settings - IDK settings
  Users create IDK settings for custom response
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Behavior Settings" menu item
    And Create random number and save it as "id"

    And Set IDK settings
      | behaviorSettings | Custom Response   |
      | message   | Custom Response ${id}    |

    When API: Select "chatbotForAutomation" chatbot
    And API: Send first message "${IDK_QUESTION}" and save response as "chatbotResponse"
    And Retrieve "body.context.conversation_id" from "chatbotResponse" and save as "conversationId"
    And Verify that response "chatbotResponse" has field "body.output.text[0]" equal to "<p>Sorry, I don't have the answer to that.</p>"
    And API: Send message
      | message             | Yes, please     |
      | conversationIdAlias | conversationId  |
      | saveResponseAs      | response        |
    And Verify that response "response" has field "body.output.text[0]" equal to "<p>I can help you reach someone.</p>"

    And API: Send message
      | message             | Office 1         |
      | conversationIdAlias | conversationId  |
      | saveResponseAs      | response        |
    And Verify that response "response" has field "body.output.text[0]" equal to "<p>Custom Response ${id}</p>"


  Scenario: Behavior Settings - IDK contact form
  Users agrees to fill the contact form
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Behavior Settings" menu item
    And Create random number and save it as "id"
    And Remove incoming messages from automation inbox

    And Set IDK settings
      | behaviorSettings | Contact Form                                                                         |
      | message          | Great, your message has been sent. Someone will get back to you as soon as possible. |
      | email            | automation@dqwhivf6.mailosaur.net                                                    |
      | phone            | checked                                                                              |
      | studentId        | unchecked                                                                            |

    When API: Select "chatbotForAutomation" chatbot
    And API: Send first message "Hi" and save response as "chatbotResponse"
    And Retrieve "body.context.conversation_id" from "chatbotResponse" and save as "conversationId"
    And API: Send message
      | message             | ${IDK_QUESTION} |
      | conversationIdAlias | conversationId  |
    And API: Send message
      | message             | Yes, please    |
      | conversationIdAlias | conversationId |
    And API: Send message
      | message             | Office 1       |
      | conversationIdAlias | conversationId |
    And API: Send message
      | message             | AutomationUser |
      | conversationIdAlias | conversationId |
    And API: Send message
      | message             | email${id}@automation.com |
      | conversationIdAlias | conversationId            |
    And API: Send message
      | message             | 111-222-${id}  |
      | conversationIdAlias | conversationId |
    And API: Send message
      | message             | no             |
      | conversationIdAlias | conversationId |

    Then Get last email with subject "Chatbot Submission" and save it as "email"
    And Verify that "email" contains "${IDK_QUESTION}"
    And Verify that "email" contains "email${id}@automation.com"
    And Verify that "email" contains "111-222-${id}"