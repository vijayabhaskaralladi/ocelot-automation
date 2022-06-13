Feature: Integrations

  # Waiting for Applications page update
  @need_to_fix
  Scenario: Access to Integrations->Applications page
    Given Login using random user from the list
      | campaignsLimited  |
      | campaignsStandard |
      | campaignsAdmin    |
      | chatbotLimited    |
      | chatbotStandard   |
      | chatbotAdmin      |
    And Open chatbot "chatbotForAutomation"
    When Open "Integrations->Applications" menu item
    Then Verify that page contains titles "LibAnswers;ServiceNow"
    And Tag "h2" with text "Zoom" should "not.exist"

  Scenario: Live Chat users should see Zoom app on Integrations->Applications page
    Given Login using random user from the list
      | liveChatLimited   |
      | liveChatStandard  |
      | liveChatAdmin     |
    And Open chatbot "chatbotForAutomation"
    When Open "Integrations->Applications" menu item
    Then Verify that page contains titles "Zoom;LibAnswers;ServiceNow"

  Scenario: Viewing Authentication Providers page
    Given Login as 'chatbotAdmin'
    And Open chatbot "chatbotForAutomation"
    When Open "Integrations->Authentication Providers" menu item
    And Click on "integrations.authenticationProviders.addNewAuthenticationProviderButton"
    Then Verify that page contains element "integrations.dialogTitle" with text "Create Authentication Provider"

  Scenario: Viewing Service Providers page
    Given Login as 'chatbotAdmin'
    And Open chatbot "chatbotForAutomation"
    When Open "Integrations->Service Providers" menu item
    And Click on "integrations.serviceProviders.addNewServiceProviderButton"
    Then Verify that page contains element "integrations.dialogTitle" with text "Create Service Provider"

  Scenario: Viewing SFTP Users page
    Given Login as 'campaignsAdmin'
    And Open chatbot "chatbotForAutomation"
    When Open "Integrations->SFTP Users" menu item
    And Click on "integrations.sftpUsers.addNewSftpUserButton"
    Then Verify that page contains element "integrations.dialogTitle" with text "Create SFTP User"

  Scenario: Limited users don't see Authentication Providers, Service Providers and SFTP Users pages
    Given Login using random user from the list
      | chatbotLimited    |
      | chatbotStandard   |
      | liveChatLimited   |
      | liveChatStandard  |
      | campaignsLimited  |
      | campaignsStandard |
    When Open "Integrations" menu item
    Then Tag "span.MuiButton-label" with text "Authentication Providers" should "not.exist"
    And Tag "span.MuiButton-label" with text "Service Providers" should "not.exist"
    And Tag "span.MuiButton-label" with text "SFTP Users" should "not.exist"
