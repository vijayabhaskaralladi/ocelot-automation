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

    When Set operator status to "available"
    Then Tag "div" with text "You set your status to available." should "exist"

    When Set operator status to "away"
    Then Tag "div" with text "You set your status to away" should "exist"