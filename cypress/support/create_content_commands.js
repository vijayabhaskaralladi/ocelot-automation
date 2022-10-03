Cypress.Commands.add('openCreateOneToOneTextModal', () => {
  cy.getElement('createContent.createContentMenuButton').click();
  cy.contains('li', 'Create 1:1 Text').click();
});

Cypress.Commands.add('openCreateCampaignModal', () => {
  cy.getElement('createContent.createContentMenuButton').click();
  cy.getElement('createContent.createCampaign').click();
});

Cypress.Commands.add('openAddNewCustomVariableModal',()=>{
  // Click on Add new custom variable button
  cy.getElement('chatbot.variables.addNewCustomVariableButton').click();
})
