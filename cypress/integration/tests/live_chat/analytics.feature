Feature: Permissions - Live Chat analytics dashboard

  Scenario: Viewing Live Chat Analytics Dashboard
    Given Login using random user from the list
      | viewOtherOfficesLiveChat |
      | liveChatStandard         |
      | liveChatAdmin            |
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat->Analytics->Dashboard" menu item
    And Verify that page title is "Dashboard"
    Then Verify that element "liveChat.analytics.chatsNumber" contains positive number

  @low_priority
  Scenario: Limited users can't open Live Chat item
    Given Login using random user from the list
      | viewOtherOfficesChatbot   |
      | viewOtherOfficesCampaigns |
      | chatbotLimited            |
      | chatbotStandard           |
      | chatbotAdmin              |
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
    And Open chatbot "chatbotForAutomation"
    Then Tag "li>button" with text "Live Chat" should "not.exist"

  @low_priority
  Scenario Outline: TMD-51: Verify that user <user_name> can't open Live Chat->Analytics item
    Given Login as "<user_name>"
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat" menu item
    Then Tag "li>a" with text "Analytics" should "not.exist"
    Examples:
      | user_name       |
      | liveChatLimited |

  @low_priority
  Scenario: Viewing Missed Chats page
    Given Login using random user from the list
      | viewOtherOfficesLiveChat |
      | liveChatStandard         |
      | liveChatAdmin            |
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat->Analytics->Missed Chats" menu item
    Then Verify that element "liveChat.analytics.missedChatsNumber" contains positive number
    And Verify that element "liveChat.analytics.averagePerDayMissedChatsNumber" contains positive number
