Feature: Permissions - create new question button

  @ignore @need_to_fix
  Scenario Outline: Verify that user <user_name> can see Create Question button
    Given Login as "<user_name>"
    When Open chatbot "chatbotForAutomation"
    Then Element "createContent.createContentMenuButton" should "exist"
    Examples:
      | user_name               |
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |

  @ignore @need_to_fix
  Scenario Outline: Verify that user <user_name> can't see Create Question button
    Given Login as "<user_name>"
    When Open chatbot "chatbotForAutomation"
    Then Element "createContent.createContentMenuButton" should "not.exist"
    Examples:
      | user_name                 |
      | chatbotLimited            |
      | viewOtherOfficesLiveChat  |
      | viewOtherOfficesCampaigns |
      | liveChatLimited           |
      | liveChatStandard          |
      | liveChatAdmin             |
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
