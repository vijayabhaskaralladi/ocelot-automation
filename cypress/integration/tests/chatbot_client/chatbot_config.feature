Feature: Chatbot config detection

  Scenario: Check chatbot config data
    When API: Select "chatbotForAutomation" chatbot
    And API: Get chatbot config and save it as "chatbotConfigResponse"
    Then Verify that response "chatbotConfigResponse" has status code "200"
    And Verify that response "chatbotConfigResponse" has field "body.name" equal to "automation chatbot"
    And Verify that response "chatbotConfigResponse" has field "body.callout_heading" equal to "May I help you?"
