import { And } from 'cypress-cucumber-preprocessor/steps';

And('Set operator status to {string}', (status) => {
  // ToDo: command doesn't verify current state
  cy.log(`Set operator status: ${status}`);
  cy.get('span.MuiBadge-root>div').click();
  cy.get('span>input').click();
  cy.get('#notistack-snackbar', { timeout: 5000 }).should('be.visible');
});
