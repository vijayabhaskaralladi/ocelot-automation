Feature: Service Now integration

  Scenario: Service Now integration
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Intercept "${GRAPHQL_URL}graphql" with "getLiveChatOperator" keyword in the response as "liveChatRequest"
    And Open "Integrations->Applications" menu item
    And Wait for "liveChatRequest" network call
    And Retrieve "request.headers.authorization" from "liveChatRequest" and save as "token"
    And Retrieve "request.headers.x-contextual-entity" from "liveChatRequest" and save as "contextualEntity"
    And API: Select "chatbotForAutomation" chatbot

    When Enable Service Now
      | baseUrl          | https://dev128364.service-now.com/ |
      | authToken        | ${token}                           |
      | contextualEntity | ${contextualEntity}                |
    And Open chatbot "chatbotForAutomation"
    And Open "Integrations->Applications" menu item
    Then API: Send first message "Where can I obtain updates and new releases for Mac OS X?" and save response as "response"
    And Verify that response "response" has field "body.output.text[0]" equal to "<p>I have a link in the explore bar below that may answer your question.</p>"

    When Disable Service Now
      | authToken        | ${token}                           |
      | contextualEntity | ${contextualEntity}                |
    And Wait "3000"
    Then API: Send first message "Where can I obtain updates and new releases for Mac OS X?" and save response as "response"
    And Verify that response "response" has field "body.output.text[0]" equal to "<p>Sorry, I don't have the answer to that.</p>"
