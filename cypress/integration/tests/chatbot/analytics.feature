Feature: Permissions - chatbot analytics

  Scenario: TMD-13: Viewing Chatbot Analytics
  Test verifies that Analytics dashboard updates values after a conversation
    Given Login using random user from the list
      | viewOtherOfficesChatbot |
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
    And Open chatbot "chatbotForAutomation"

    When Intercept "${GRAPHQL_URL}graphql" with "getChatbotStats" keyword in the response as "analyticsRequest"
    And Open "Chatbot->Analytics" menu item
    And Wait for "analyticsRequest" network call
    Then Verify that element "chatbot.analytics.conversationsNumber" contains positive number
    And Verify that element "chatbot.analytics.interactionsNumber" contains positive number

    And Retrieve text from "chatbot.analytics.conversationsNumber" and save as "conversationsNumber1"
    And Retrieve text from "chatbot.analytics.interactionsNumber" and save as "interactionsNumber1"

#    MAINT-2236: Chatbot analytics doesn't update values immediately
#    When API: Select "chatbotForAutomation" chatbot
#    And API: Create dialog and save conversation_id as "conversationId"
#    And API: Send message
#      | message             | Second message |
#      | conversationIdAlias | conversationId |
#    And API: Send message
#      | message             | Third message  |
#      | conversationIdAlias | conversationId |
#    And API: Send message
#      | message             | Fourth message |
#      | conversationIdAlias | conversationId |
#
#    And Open chatbot "chatbotForAutomation"
#    And Open "Chatbot->Analytics" menu item
#    And Wait for "analyticsRequest" network call
#
#    And Retrieve text from "chatbot.analytics.conversationsNumber" and save as "conversationsNumber2"
#    And Retrieve text from "chatbot.analytics.interactionsNumber" and save as "interactionsNumber2"
#
#    And Check that difference between "conversationsNumber2" and "conversationsNumber1" is "1"
#    And Check that difference between "interactionsNumber2" and "interactionsNumber1" is "4"

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

#    MAINT-2236: Chatbot analytics doesn't update values immediately
#    When API: Select "chatbotForInquiryForm" chatbot
#    And API: Send first message "Skip questions" and save response as "chatbotResponse"
#    And Retrieve "body.context.conversation_id" from "chatbotResponse" and save as "conversationId"
#    And API: Send message
#      | message             | What is FAFSA? |
#      | conversationIdAlias | conversationId |
#
#    And Open chatbot "chatbotForAutomation"
#    And Open "Chatbot->Analytics" menu item
#    And Click on "chatbot.analytics.filter"
#    And Click on "chatbot.analytics.chatbotDropdown"
#    And Click on tag "li" which contains text "AutomationInquiryForm"
#    And Retrieve text from "chatbot.analytics.conversationsNumber" and save as "conversationsNumber2"
#    And Retrieve text from "chatbot.analytics.interactionsNumber" and save as "interactionsNumber2"
#
#    Then Check that difference between "conversationsNumber2" and "conversationsNumber1" is "1"
#    And Check that difference between "interactionsNumber2" and "interactionsNumber1" is "2"

  Scenario: Viewing Chatbot Analytics - by office
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"

    When Open "Chatbot->Analytics" menu item
    And Click on "chatbot.analytics.filter"
    And Click on "chatbot.analytics.officeDropdown"
    And Click on tag "li" which contains text "MyCampus - Office 2"

    Then Verify that element "chatbot.analytics.conversationsNumber" contains positive number
    And Verify that element "chatbot.analytics.interactionsNumber" contains positive number
    And Retrieve text from "chatbot.analytics.conversationsNumber" and save as "conversationsNumber1"
    And Retrieve text from "chatbot.analytics.interactionsNumber" and save as "interactionsNumber1"

#    MAINT-2236: Chatbot analytics doesn't update values immediately
#    When API: Select "chatbotForAutomation" chatbot
#    And Create random number and save it as "id"
#    And API: Send first message to specific Office
#      | message        | Analytics, Office 2 ${id}        |
#      | officeId       | ${chatbotForAutomationOffice2Id} |
#      | campusId       | ${chatbotForAutomationCampusId}  |
#      | saveResponseAs | response                         |
#
#    And Open chatbot "chatbotForAutomation"
#    And Open "Chatbot->Analytics" menu item
#    And Click on "chatbot.analytics.filter"
#    And Click on "chatbot.analytics.officeDropdown"
#    And Click on tag "li" which contains text "MyCampus - Office 2"
#    And Retrieve text from "chatbot.analytics.conversationsNumber" and save as "conversationsNumber2"
#    And Retrieve text from "chatbot.analytics.interactionsNumber" and save as "interactionsNumber2"
#
#    Then Check that difference between "conversationsNumber2" and "conversationsNumber1" is "1"
#    And Check that difference between "interactionsNumber2" and "interactionsNumber1" is "1"

  Scenario: Limited users can't view Chatbot Analytics
    Given Login using random user from the list
      | viewOtherOfficesLiveChat  |
      | viewOtherOfficesCampaigns |
      | liveChatLimited           |
      | liveChatStandard          |
      | liveChatAdmin             |
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot" menu item
    Then Tag "span.MuiButton-label" with text "Analytics" should "not.exist"
