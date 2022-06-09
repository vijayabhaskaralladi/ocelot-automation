Feature: Permissions - Live Chat analytics dashboard

  Scenario: Viewing Live Chat Analytics Dashboard
    Given Login using random user from the list
      | viewOtherOfficesLiveChat |
      | liveChatStandard         |
      | liveChatAdmin            |
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat->Analytics->Dashboard" menu item
    Then Verify that element "liveChat.analytics.chatsNumber" contains positive number

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
    When Open "" menu item
    Then Tag "span.MuiButton-label" with text "Live Chat" should "not.exist"

  Scenario Outline: TMD-51: Verify that user <user_name> can't open Live Chat->Analytics item
    Given Login as "<user_name>"
    And Open chatbot "chatbotForAutomation"
    When Open "Live Chat" menu item
    Then Tag "span.MuiButton-label" with text "Analytics" should "not.exist"
    Examples:
      | user_name       |
      | liveChatLimited |
