Feature: Permissions - create campaigns

  Scenario: TMD-25: Creating Campaign from a template
    Given Login using random user from the list
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    And Create random number and save it as "randomNumber"
    And Element "createContent.createContentMenuButton" should "exist"
    When Create campaign from template
      | campaignName              | templateName            | contactListName     |
      | MyCampaign${randomNumber} | ${campaignTemplateName} | ContactListForTests |
    Then Verify that page title is "MyCampaign"

  Scenario: TMD-26: Limited users can't Create Campaigns
    Given Login using random user from the list
      | campaignsLimited         |
      | viewOtherOfficesLiveChat |
      | liveChatLimited          |
      | liveChatStandard         |
      | liveChatAdmin            |
      | chatbotLimited           |
      | chatbotStandard          |
      | chatbotAdmin             |
    Then Element "button[aria-label='Create Content']:not([title])" should "not.exist"
    And Tag "li" with text "Create Campaign" should "not.exist"

