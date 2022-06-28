import {And} from 'cypress-cucumber-preprocessor/steps';
import {convertDataTableIntoDict} from "../../support/utils";

And('Send 1:1 message', (datatable) => {
  const messageData = convertDataTableIntoDict(datatable);

  cy.openCreateOneToOneTextModal();

  const fromDropdown = 'input[aria-labelledby="phoneNumberListSelect"]';
  cy.get(fromDropdown).click();
  cy.replacePlaceholder(messageData.from).then((from) => {
    cy.contains('span', from).click();
  });

  const toInput = 'input[name="smsTo"]'
  cy.replacePlaceholder(messageData.to).then((to) => {
    cy.get(toInput).type(to);
  });

  const messageInput = 'div[aria-label="Rich Text Editor, Message"]';
  cy.replacePlaceholder(messageData.message).then((message) => {
    cy.get(messageInput).type(message);
  });

  cy.contains('span', 'Send').click();
});