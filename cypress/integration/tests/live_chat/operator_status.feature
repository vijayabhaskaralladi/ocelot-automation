Feature: Live Chat - Operator Status

  Scenario: Changing operator status
    Given Login using random user from the list
      | viewOtherOfficesLiveChat |
      | liveChatLimited          |
      | liveChatStandard         |
      | liveChatAdmin            |
    And Open chatbot "chatbotForAutomation"
    And Intercept "${GRAPHQL_URL}graphql" with "setLiveChatOperatorStatus" keyword in the response as "changeStatusRequest"
    And Intercept "${GRAPHQL_URL}graphql" with "getLiveChatOperatorStatus" keyword in the response as "getOperatorStatusRequest"

    When Set operator status to "available"
    And Wait for "changeStatusRequest" network call
    And Wait for "getOperatorStatusRequest" network call

    Then Verify that response "changeStatusRequest" has status code "200"
    And Verify that response "getOperatorStatusRequest" has status code "200"
    And Verify that response "changeStatusRequest" has field "response.body.data.setLiveChatOperatorStatus" equal to "Available"
    And Verify that response "getOperatorStatusRequest" has field "response.body.data.getLiveChatOperatorStatus" equal to "Available"
    And Tag "div" with text "You set your status to available." should "exist"

    When Set operator status to "away"
    And Wait for "changeStatusRequest" network call
    And Wait for "getOperatorStatusRequest" network call

    Then Verify that response "changeStatusRequest" has status code "200"
    And Verify that response "getOperatorStatusRequest" has status code "200"
    And Verify that response "changeStatusRequest" has field "response.body.data.setLiveChatOperatorStatus" equal to "Away"
    And Verify that response "getOperatorStatusRequest" has field "response.body.data.getLiveChatOperatorStatus" equal to "Away"
    And Tag "div" with text "You set your status to away" should "exist"