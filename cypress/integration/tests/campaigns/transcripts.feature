Feature: Permissions - campaigns transcripts

  Scenario: Viewing Campaigns Transcripts
    Given Login using random user from the list
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    And Open chatbot "chatbotForAutomation"
    When Open "Campaigns->Transcripts" menu item
    Then Verify that browser tab title contains "Transcripts"

  Scenario Outline: Verify that user <user_name> can't see Campaigns Transcripts
    Given Login as "<user_name>"
    And Open chatbot "chatbotForAutomation"
    And Open "Campaigns" menu item
    Then Tag "span.MuiButton-label" with text "Transcripts" should "not.exist"
    Examples:
      | user_name        |
      | campaignsLimited |

    @exclude_from_ci
    Scenario Outline: TMD-84: Verify that user is able to View Campaigns Transcripts  conversation
      Given Login as "<user_name>"
      And Open chatbot "chatbotForAutomation"
      And Create random number and save it as "randomNumber"
      And Click on "createContent.createContentMenuButton"
      And Click on "createContent.campaigns.createFromScratch"
      And Type "ContactListForTests" in "createContent.campaigns.searchInput"
      And Click on "createContent.campaigns.addContactListButton"
      And Type "MyCampaign ${randomNumber}" in "createContent.campaigns.campaignTitleInput"
      And Click on "createContent.campaigns.campusAndOfficeInput"
      And Click on "createContent.campaigns.сampusAndOfficeDropdown"
      And Type "Automation campaign Content ${randomNumber}" in "createContent.campaigns.campaignContent"
      And Type "Automationtag{enter}" in "createContent.campaigns.campaignTags"
      And Type "{enter}{downArrow}{enter}" in "createContent.campaigns.campaignInboxes"
      And Click on "createContent.campaigns.saveCampaignButton"
      And Select available Phone number from phone number list
      And Click on "createContent.campaigns.launchButton"
      And Type "Keyword for campaign Transcript ${randomNumber}" in "createContent.campaign.conversation"
      And Open "Campaigns.Transcripts" menu item
      And Click on "createContent.campaigns.viewConversation"
      Then Tag "span.MuiListItem" with text "Keyword for campaign Transcript ${randomNumber}" should "exist"
      Examples:
        | user_name        |
        | campaignsAdmin   |