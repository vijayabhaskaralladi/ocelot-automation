import { And } from 'cypress-cucumber-preprocessor/steps';
import {convertDataTableIntoDict, validateInputParamsAccordingToDict} from '../../support/utils';

And('Create custom question', (datatable) => {
  //ToDo: add support of Clarifying Questions
  const questionData = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    question: 'any',
    response: 'any',
    library: 'any',
    category: 'any',
    contentLock: 'any',
    contentSharing: 'any'
  };
  validateInputParamsAccordingToDict(questionData, requiredParametersAndAcceptableValues);
  cy.task('log', `Creating Custom Question: ${questionData.question}`);

  // Create Content menu
  const createContentButton = '[aria-label="Create Content"]';
  cy.get(createContentButton).click();
  cy.contains('li', 'Create Question').click();

  cy.replacePlaceholder(questionData.question).then((question) => {
    const questionInput = '[aria-label="Question"]';
    cy.get(questionInput).type(question);
  });

  cy.replacePlaceholder(questionData.response).then((response) => {
    const responseInput = '[data-slate-editor="true"]';
    cy.get(responseInput).type(response);
  });

  // Library
  cy.replacePlaceholder(questionData.library).then((library) => {
    const libraryDropdown = '#multiple-libraries-tags';
    const libraryItem = '#multiple-libraries-tags-listbox>li';
    cy.get(libraryDropdown).click();
    cy.contains(libraryItem, library).click();
  });

  // Category
  cy.replacePlaceholder(questionData.category).then((category) => {
    const categoryDropdown = '#multiple-categories-tags';
    const categoryItem = '#multiple-categories-tags-listbox>li';
    cy.get(categoryDropdown).click();
    cy.contains(categoryItem, category).click();
  });

  // switches
  cy.replacePlaceholder(questionData.contentLock).then((contentLock) => {
    if (contentLock === 'enabled') {
      const contentLockSwitch = '#contentLock';
      cy.get(contentLockSwitch).click();
    }
  });
  cy.replacePlaceholder(questionData.contentSharing).then((contentSharing) => {
    if (contentSharing === 'enabled') {
      const contentSharingSwitch = '#contentShare';
      cy.get(contentSharingSwitch).click();
    }
  });

  // Save
  const saveButton = 'button.css-vgocey';
  cy.get(saveButton).click();

  // Check message
  const expectedSaveNotification = 'Your question has been queued for review. It should be published within two business days.';
  cy.checkNotificationMessage(expectedSaveNotification);
});
