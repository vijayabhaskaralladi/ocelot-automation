import {And} from 'cypress-cucumber-preprocessor/steps';
import {convertDataTableIntoDict, validateInputParamsAccordingToDict} from '../../support/utils';

And('Create Clarifying Question', (datatable) => {
  //The step supports 2-4 choices
  const clarifyingQuestionData = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    title: 'any',
    question: 'any',
    choices: 'any'
  };
  validateInputParamsAccordingToDict(clarifyingQuestionData, requiredParametersAndAcceptableValues);

  const addQuestionButton = 'button[aria-label="Create Clarifying Question"]';
  cy.get(addQuestionButton).click();

  cy.replacePlaceholder(clarifyingQuestionData.title).then((title) => {
    const titleInput = 'input[placeholder="Add title"]';
    cy.get(titleInput).type(title);
  });
  cy.replacePlaceholder(clarifyingQuestionData.question).then((question) => {
    const questionInput = 'input[placeholder="Add question"]';
    cy.get(questionInput).type(question);
  });

  cy.wrap().then(() => {
    const choices = clarifyingQuestionData.choices.split(';');
    const choiceInput = 'input[placeholder="Add choice"]';
    if (choices.length === 1) {
      throw Error('At least 2 choices required');
    }
    cy.get(choiceInput).eq(0).type(choices[0]);
    cy.get(choiceInput).eq(1).type(choices[1]);
    if (choices.length === 3) {
      cy.contains('button', 'Add Choice').click();
      cy.get(choiceInput).eq(2).type(choices[2]);
    }
    if (choices.length === 4) {
      cy.contains('button', 'Add Choice').click();
      cy.get(choiceInput).eq(2).type(choices[2]);
      cy.contains('button', 'Add Choice').click();
      cy.get(choiceInput).eq(3).type(choices[3]);
    }
  });
  cy.contains('button', 'Save').click();
  cy.checkNotificationMessage('Saved');
});
