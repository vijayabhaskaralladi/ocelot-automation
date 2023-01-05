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

  @do_not_run_on_com
  Scenario: Viewing Who is Online when someone is online
    Given Login using random user from the list
      | viewOtherOfficesLiveChat |
      | liveChatLimited          |
      | liveChatStandard         |
      | liveChatAdmin            |
    And Open chatbot "chatbotForAutomation"
    And Set operator status to "available"
    When Open "Live Chat->Who’s Online" menu item
    Then Verify that element "liveChat.whosOnline.agentsOnline" has number greater than "1"
    And Verify that element "liveChat.whosOnline.totalAgents" contains positive number
