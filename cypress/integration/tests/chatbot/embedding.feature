Feature: Embedding

  Scenario: TMD-12: Verify that Chatbot->Embedding page contains correct JS script
    Given Login as "defaultUser"
    When Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Embedding" menu item
    Then Verify that embedded script contains id for "chatbotForAutomation" chatbot

    When Click on "chatbot.embedding.officeDropdown"
    And Click on tag "span" which contains text "MyCampus - Office 1"
    Then Tag "span" with text "campus_id=${chatbotForAutomationCampusId}" should "exist"
    And Tag "span" with text "office_id=${chatbotForAutomationOffice1Id}" should "exist"

    When Open chatbot "aimsCommunityCollege"
    And Open "Chatbot->Embedding" menu item
    Then Verify that embedded script contains id for "aimsCommunityCollege" chatbot
