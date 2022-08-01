import { And } from 'cypress-cucumber-preprocessor/steps';

And('Set content sharing switch to {string}', (contentShareState) => {
  const contentShareSwitchSelector = '#contentShare';
  cy.get(contentShareSwitchSelector).invoke('attr','value').then(switchState => {
    if((switchState === 'false' && contentShareState === 'enabled') || (switchState === 'true' && contentShareState === 'disabled')) {
      cy.get(contentShareSwitchSelector).click();
    }
  });
});