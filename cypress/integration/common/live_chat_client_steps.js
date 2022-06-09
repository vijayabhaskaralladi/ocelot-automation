import { And } from 'cypress-cucumber-preprocessor/steps';

And('Open chatbot window', () => {
  cy.get("button[aria-label*='Click to open Arty']").click();
});

And('Start Live Chat', () => {
  cy.intercept('https://ai.plaidbean.com/api/message').as('chatBotResponse');
  // cy.get("button[aria-label*='Click to open Arty']").click();
  cy.contains('span', 'Financial Aid OFFICE').click();
  cy.wait('@chatBotResponse');
  cy.wait(1000);
  cy.contains('span', 'Yes').click();
  cy.wait('@chatBotResponse');
  cy.wait(1000);
});
