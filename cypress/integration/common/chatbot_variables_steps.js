import {And} from 'cypress-cucumber-preprocessor/steps';
import {convertDataTableIntoDict, validateInputParamsAccordingToDict} from '../../support/utils';

And('Create chatbot variable', (datatable) => {
  const variableData = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    variableName: 'any',
    placeHolder: 'any',
    type: ['number', 'text', 'rich text', 'link', 'dropdown', 'email address', 'url']
  };

  cy.openAddNewCustomVariableModal();

  cy.replacePlaceholder(variableData.variableName).then((variableName) => {
    cy.getElement('chatbot.variables.variableName').type(variableName);
  });

  cy.replacePlaceholder(variableData.placeHolder).then((placeHolder) => {
    cy.getElement('chatbot.variables.variablePlaceholder').type(placeHolder);
  });

  cy.replacePlaceholder(variableData.type).then((type) => {
    variableData.type = type;
    validateInputParamsAccordingToDict(variableData, requiredParametersAndAcceptableValues);
    cy.getElement('chatbot.variables.variableType').click({ force: true });
    cy.contains('li.MuiListItem-button', type).click({ force: true });

    // Provide the value for fields based on selected datatype
    switch (type.toLowerCase()) {
    case 'number':
      cy.replacePlaceholder(variableData.numberValue).then((numberValue) => {
        cy.getElement('chatbot.variables.variableValue').type(numberValue);
      });
      break;
    case 'text':
      cy.replacePlaceholder(variableData.textValue).then((textValue) => {
        cy.getElement('chatbot.variables.variableValue').type(textValue);
      });
      break;
    case 'email address':
      cy.replacePlaceholder(variableData.emailValue).then((emailValue) => {
        cy.getElement('chatbot.variables.variableValue').type(emailValue);
      });
      break;
    case 'url':
      cy.replacePlaceholder(variableData.linkURL).then((linkURL) => {
        cy.getElement('chatbot.variables.variableValue').type(linkURL);
      });
      break;
    case 'rich text':
      cy.replacePlaceholder(variableData.richTextValue).then((richTextValue) => {
        cy.getElement('chatbot.variables.variableRichTextValue').type(richTextValue);
      });
      break;
    case 'link':
      cy.replacePlaceholder(variableData.linkText).then((linkText) => {
        cy.getElement('chatbot.variables.variableLinkTextValue').type(linkText);
      });

      cy.replacePlaceholder(variableData.linkURL).then((linkURL) => {
        cy.getElement('chatbot.variables.variableLinkURLValue').type(linkURL);
      });
      break;
    case 'dropdown':
      cy.getElement('chatbot.variables.editAllowedValuesButton').click({force:true});
      cy.replacePlaceholder(variableData.dropDownValue).then((dropDownValue) => {
        cy.getElement('chatbot.variables.dropdownOptionValues').type(dropDownValue);
      });
      cy.getElement('chatbot.variables.editAllowedValuesButton').click({force:true});
    }

    // Click on Save button
    cy.contains('span.MuiButton-label','Save').click();
  });
});

And('Delete variable by name {string}', (variableName) => {
  cy.replacePlaceholder(variableName).then((varName) => {
    const variableNamesColumnSelector = 'tbody.MuiTableBody-root>tr>td:nth-child(1)>p';
    cy.get(variableNamesColumnSelector).each((element, index) => {
      if (element.text() === varName) {
        const deleteButtonSelector = 'td>button:nth-child(2)';
        cy.get(deleteButtonSelector).eq(index).click({force: true});
        cy.getElement('chatbot.variables.confirmVariableDeleteButton').click({force: true});
      }
    });
  });
});
