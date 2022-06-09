Feature: Notifications

  Scenario: Notifications page - live chat users
  Live Chat users shouldn't see Inbox notification settings
    Given Login using random user from the list
      | liveChatLimited  |
      | liveChatStandard |
      | liveChatAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Notifications" menu item
    Then Verify that page contains text "Configure sounds and timings for notifications within the admin"
    And Tag "h6" with text "Live chat notifications" should "exist"
    And Tag "h6" with text "Inbox message notifications" should "not.exist"

    When Intercept "${GRAPHQL_URL}graphql" with "notificationSettings" keyword in the response as "saveRequest"
    And Click on "notifications.saveButton"

    Then Wait for "saveRequest" network call
    And Verify that response "saveRequest" has status code "200"

  Scenario: Notifications page - campaigns users
  Campaigns users shouldn't see Live Chat notification settings
    Given Login using random user from the list
      | campaignsLimited  |
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Notifications" menu item
    Then Verify that page contains text "Configure sounds and timings for notifications within the admin"
    And Tag "h6" with text "Inbox message notifications" should "exist"
    And Tag "h6" with text "Live chat notifications" should "not.exist"

    When Intercept "${GRAPHQL_URL}graphql" with "notificationSettings" keyword in the response as "saveRequest"
    And Click on "notifications.saveButton"

    Then Wait for "saveRequest" network call
    And Verify that response "saveRequest" has status code "200"
