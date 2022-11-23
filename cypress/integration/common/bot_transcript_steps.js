import { And } from 'cypress-cucumber-preprocessor/steps';

And('Open the latest transcript', () => {
  cy.get('button[aria-label="View Conversation"]').eq(0).click();
});
