import {And} from 'cypress-cucumber-preprocessor/steps';

const SERVER_ID = 'dqwhivf6';
// automation uses this inbox 'automation@dqwhivf6.mailosaur.net'

And('Remove incoming messages from automation inbox', () => {
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