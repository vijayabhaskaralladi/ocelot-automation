Feature: Live Chat - active conversations

  Scenario: Viewing Active Conversations page
    Given Login using random user from the list
      | liveChatLimited  |
      | liveChatStandard |
      | liveChatAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Intercept "${GRAPHQL_URL}graphql" with "getLiveChatConversations" keyword in the response as "activeConversationsRequest"
    And Open "Live Chat->Active Conversations" menu item
    And Wait for "activeConversationsRequest" network call
    Then Verify that response "activeConversationsRequest" has status code "200"
    And Verify that page title is "Active Conversations"
