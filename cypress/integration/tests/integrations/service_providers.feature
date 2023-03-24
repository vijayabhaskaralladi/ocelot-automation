Feature: Service Providers

  @do_not_run_on_com
  Scenario: Service Providers page smoke test
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"

    When Open "Integrations->Service Providers" menu item
    Then Verify that page title is "Service Providers"

    When Click on "[aria-label='Add new Service Provider']"
    Then Tag "h1" with text "Create Service Provider" should "exist"

