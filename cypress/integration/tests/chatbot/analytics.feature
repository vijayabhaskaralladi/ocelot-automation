Feature: Permissions - chatbot analytics

  Scenario: TMD-13: Viewing Chatbot Analytics
    Given Login using random user from the list
      | viewOtherOfficesChatbot |
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
    And Open chatbot "chatbotForAutomation"

    And Open "Chatbot->Analytics" menu item
    Then Verify that element "chatbot.analytics.conversationsNumber" contains positive number
    And Verify that element "chatbot.analytics.interactionsNumber" contains positive number

    And Retrieve text from "chatbot.analytics.conversationsNumber" and save as "conversationsNumber1"
    And Retrieve text from "chatbot.analytics.interactionsNumber" and save as "interactionsNumber1"

    When API: Select "chatbotForAutomation" chatbot
    And API: Create dialog and save conversation_id as "conversationId"
    And API: Send message
      | message             | Second message |
      | conversationIdAlias | conversationId |
    And API: Send message
      | message             | Third message  |
      | conversationIdAlias | conversationId |
    And API: Send message
      | message             | Fourth message |
      | conversationIdAlias | conversationId |

    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Analytics" menu item
    And Retrieve text from "chatbot.analytics.conversationsNumber" and save as "conversationsNumber2"
    And Retrieve text from "chatbot.analytics.interactionsNumber" and save as "interactionsNumber2"

    And Check that difference between "conversationsNumber2" and "conversationsNumber1" is "1"
    And Check that difference between "interactionsNumber2" and "interactionsNumber1" is "4"

  Scenario: Viewing Child bot Analytics
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"

    When Open "Chatbot->Analytics" menu item
    And Click on "chatbot.analytics.filter"
    And Click on "chatbot.analytics.chatbotDropdown"
    And Click on tag "li" which contains text "AutomationInquiryForm"

    Then Verify that element "chatbot.analytics.conversationsNumber" contains positive number
    And Verify that element "chatbot.analytics.interactionsNumber" contains positive number

    And Retrieve text from "chatbot.analytics.conversationsNumber" and save as "conversationsNumber1"
    And Retrieve text from "chatbot.analytics.interactionsNumber" and save as "interactionsNumber1"

    When API: Select "chatbotForInquiryForm" chatbot
    And API: Create dialog and save conversation_id as "conversationId"

    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Analytics" menu item
    And Click on "chatbot.analytics.filter"
    And Click on "chatbot.analytics.chatbotDropdown"
    And Click on tag "li" which contains text "AutomationInquiryForm"
    And Retrieve text from "chatbot.analytics.conversationsNumber" and save as "conversationsNumber2"
    And Retrieve text from "chatbot.analytics.interactionsNumber" and save as "interactionsNumber2"

    Then Check that difference between "conversationsNumber2" and "conversationsNumber1" is "1"
    And Check that difference between "interactionsNumber2" and "interactionsNumber1" is "1"

  Scenario: Limited users can't view Chatbot Analytics
    Given Login using random user from the list
      | viewOtherOfficesLiveChat  |
      | viewOtherOfficesC ampaigns |
      | liveChatLimited           |
      | liveChatStandard          |
      | liveChatAdmin             |
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot" menu item
    Then Tag "span.MuiButton-label" with text "Analytics" should "not.exist"
