import { And } from 'cypress-cucumber-preprocessor/steps';

And('Open the latest transcript', () => {
  cy.get("button[title='View Conversation']").eq(0).click();
});
