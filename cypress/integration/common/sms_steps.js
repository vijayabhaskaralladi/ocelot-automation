import { And } from 'cypress-cucumber-preprocessor/steps';

And('Send SMS {string} to {string} from {string}', (msg, to, from) => {
  cy.replacePlaceholder(msg).then((message) => {
    cy.replacePlaceholder(to).then((toWithReplacedPlaceholder) => {
      cy.replacePlaceholder(from).then((fromWithReplacedPlaceholder) => {
        const toNumber = toWithReplacedPlaceholder.replace(/\D/g, '');
        const fromNumber = fromWithReplacedPlaceholder.replace(/\D/g, '');
        cy.log(`Sending <${message}> to <${toNumber}> from <${fromNumber}>`);
        cy.task('log', `Sending <${message}> to <${toNumber}> from <${fromNumber}>`);
        const dataObj = {message, toNumber, fromNumber};
        cy.task('sendSms', dataObj);
      });
    });
  });
});

And('Verify that {string} number {string} {string} message', (phoneNum, expectedStatus, expectedMsg) => {
  const acceptableValues = ['received', 'not.received'];
  if (!acceptableValues.includes(expectedStatus.toLowerCase())) {
    throw Error(`Unsupported value ${expectedStatus}. Please use one of the following: ${acceptableValues.join(', ')}`);
  }
  cy.replacePlaceholder(phoneNum).then((number)=> {
    const numberParsed = number.replace(/\D/g, '');
    cy.replacePlaceholder(expectedMsg).then((message) => {
      const dataObj = {message, number: numberParsed};
      const length = expectedStatus.toLowerCase() === 'received' ? 1 : 0;
      cy.task('verifyThatNumberReceivedSms', dataObj).should('have.length', length);
    });
  });
});

And('Verify that last SMS for number {string} has text {string}', (phoneNum, text) => {
  const number = phoneNum.replace(/\D/g, '');
  cy.replacePlaceholder(text).then((uniqueText) => {
    cy.task('getLastIncomingSmsForNumber', number).its('body').should('contain.text', uniqueText);
  });
});
