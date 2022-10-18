import {And} from 'cypress-cucumber-preprocessor/steps';
import {convertDataTableIntoDict, validateInputParamsAccordingToDict} from '../../support/utils';

And('Configure columns for contact list', (datatable) => {
  const columnsData = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    header1: ['first name', 'last name', 'email address', 'phone number'],
    header2: ['first name', 'last name', 'email address', 'phone number'],
    header3: ['first name', 'last name', 'email address', 'phone number'],
    header4: ['first name', 'last name', 'email address', 'phone number'],
  };
  validateInputParamsAccordingToDict(columnsData, requiredParametersAndAcceptableValues);
  cy.getElement('contactManagement.contactLists.header1Input').click();
  cy.contains('span', columnsData.header1).click();
  cy.getElement('contactManagement.contactLists.header2Input').click();
  cy.contains('span', columnsData.header2).click();
  cy.getElement('contactManagement.contactLists.header3Input').click();
  cy.contains('span', columnsData.header3).click();
  cy.getElement('contactManagement.contactLists.header4Input').click();
  cy.contains('span', columnsData.header4).click();
});