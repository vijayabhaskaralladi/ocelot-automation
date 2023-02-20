Feature: Live Chat - Operator Status

  Scenario: Changing operator status
    Given Login using random user from the list
      | viewOtherOfficesLiveChat |
      | liveChatLimited          |
      | liveChatStandard         |
      | liveChatAdmin            |
    # we should wait for full page load before changing operator status
    And Intercept "${GRAPHQL_URL}graphql" with "getLiveChatWhosOnlineStatistics" keyword in the response as "getStatisticsRequest"
    And Open chatbot "chatbotForAutomation"
    And Wait for "getStatisticsRequest" network call

    And Intercept "${GRAPHQL_URL}graphql" with "getLiveChatOperatorStatus" keyword in the response as "getLiveChatRequest"
    When Set operator status to "available"
    And Wait for "getLiveChatRequest" network call
    Then Tag "div" with text "You set your status to available." should "exist"

    And Intercept "${GRAPHQL_URL}graphql" with "getLiveChatOperatorStatus" keyword in the response as "getLiveChatRequest"
    When Set operator status to "away"
    And Wait for "getLiveChatRequest" network call
    Then Tag "div" with text "You set your status to away" should "exist"