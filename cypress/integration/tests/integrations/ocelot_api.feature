Feature: Service Now integration

  @do_not_run_on_com
  Scenario: Ocelot API smoke test
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"

    When Open "Integrations->Ocelot API" menu item
    Then Tag "h1" with text "Ocelot API" should "exist"
    And Tag "div" with text "Authentication details" should "exist"
    And Tag "#chatbotUuid-label" with text "Chatbot UUID" should "exist"
