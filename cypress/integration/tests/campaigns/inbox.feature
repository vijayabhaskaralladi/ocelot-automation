Feature: Inbox

  Scenario: Inbox - managing subscription
    Given Login as "campaignsAdmin"
    And Open chatbot "chatbotForAutomation"
    And Create random number and save it as "id"
    And Save "(513) 586-1971" as "firstContact"
    And Save "campaigns@automation.com" as "firstContactEmail"
    And Archive campaign which uses "${PROVISION_NUMBER}" number

    When Create campaign
      | campaignName     | MyCampaign${id}           |
      | createFrom       | Scratch                   |
      | contentType      | simple                    |
      | contactList      | ContactListForAutomation  |
      | office           | Office 1                  |
      | message          | Hi. Simple campaign ${id} |
      | number           | ${PROVISION_NUMBER}       |
      | campaignType     | Agent                     |
      | automaticArchive | 1 day                     |
      | idkType          | Agent                     |
    And Open "Inbox" menu item
    And Manage subscriptions
      | campaignName | MyCampaign${id} |
      | action       | subscribe       |
    And Send SMS "Random message ${id}" to "${PROVISION_NUMBER}" from "${firstContact}"
    Then Tag "ul.MuiList-root" with text "Random message ${id}" should "exist"

    When Manage subscriptions
      | campaignName | MyCampaign${id} |
      | action       | unsubscribe     |
    And Send SMS "Second message ${id}" to "${PROVISION_NUMBER}" from "${firstContact}"
    Then Tag "ul.MuiList-root" with text "Second message ${id}" should "not.exist"