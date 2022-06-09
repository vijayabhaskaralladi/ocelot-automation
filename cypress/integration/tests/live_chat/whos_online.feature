Feature: Permissions - Live Chat Who's online

  Scenario: TMD-51: Viewing Who's online
    Given Login using random user from the list
      | viewOtherOfficesLiveChat |
      | liveChatLimited          |
      | liveChatStandard         |
      | liveChatAdmin            |
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat->Who’s Online" menu item
    Then Verify that element "liveChat.whosOnline.agentsOnline" contains positive number
    And Verify that element "liveChat.whosOnline.totalAgents" contains positive number
