import {And} from 'cypress-cucumber-preprocessor/steps';

const SERVER_ID = 'dqwhivf6';

And('Remove incoming messages from automation inbox', (fileName) => {
  cy.mailosaurDeleteAllMessages(SERVER_ID);
});

And('Extract link from email with subject {string} and save as {string}', (subject, alias) => {
  cy.mailosaurGetMessage(SERVER_ID, {
    subject: subject
  }).then((email) => {
    const link = email.html.links[0].href;
    cy.wrap(link).as(alias);
  });
});