import { And } from 'cypress-cucumber-preprocessor/steps';
import {convertDataTableIntoDict, validateInputParamsAccordingToDict} from '../../support/utils';

And('Create provision number', (datatable) => {
  const provisionNumberData = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    name: 'any',
    areaCode: 'any',
    office: 'any',
    responseType: ['bot', 'agent', 'none'],
    saveProvisionNumberAs: 'any',
  };
  validateInputParamsAccordingToDict(provisionNumberData, requiredParametersAndAcceptableValues);

  const createProvisionNumberButton = 'button[aria-label="Provision Reusable Number"]';
  const provisionNumberButton = 'button.MuiButton-outlinedPrimary';
  const areaCode = '#provisionNumberAreaCode';
  const numbers = '[aria-label="Available phone numbers"]>.MuiListItem-root';
  const firstAvailableNumber = '[aria-label="Available phone numbers"]>div:nth-child(1)';
  const confirmNumberButton = '.MuiDialogActions-root>button:nth-child(2)';
  const officeDropdown = '#campusOffice';

  cy.get(createProvisionNumberButton).click();
  cy.get(provisionNumberButton).click();
  cy.get(areaCode).type(provisionNumberData.areaCode);
  cy.get(numbers).should('have.length.gt', 3);

  cy.get(firstAvailableNumber).click();
  cy.get(firstAvailableNumber).invoke('text')
    .then((provisionNumber) => {
      cy.wrap(provisionNumber).as(provisionNumberData.saveProvisionNumberAs);
    });
  cy.get(confirmNumberButton).click();

  cy.replacePlaceholder(provisionNumberData.name).then((provisionNumberName) => {
    cy.get('#name').type(provisionNumberName);
  });

  cy.get('#description').type(provisionNumberData.description);
  cy.get(officeDropdown).prev().click();
  cy.contains('span.MuiTypography-displayBlock', provisionNumberData.office).click();

  cy.get('#campaignType').click();
  cy.contains('[aria-labelledby="campaignType-label"]>li.MuiListItem-root', provisionNumberData.responseType).click();

  cy.get('#inboxSubscriptions').click();
  cy.contains('span.MuiListItemText-primary', provisionNumberData.inbox).click();
  cy.contains('button>span', 'Save').click();
  cy.contains('#notistack-snackbar', 'Saved Successfully!').should('exist');
});

And('Delete provision number {string}', (provisionNumber) => {
  const deleteButton = 'button[aria-label="Revoke number"]';
  const confirmDeleteButton = '.MuiDialogActions-root>button:nth-child(2)>span';

  cy.replacePlaceholder(provisionNumber).then((number) => {
    cy.getElement('texting.phoneNumbers.searchInput').clear().type(number);
  });
  cy.getElement('texting.phoneNumbers.records').should('have.length',1);
  cy.get(deleteButton).click();
  cy.get(confirmDeleteButton).click();
  cy.contains('#notistack-snackbar', 'Phone number revoked').should('exist');
});
