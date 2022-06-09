import { getValueByPath } from './utils';

Cypress.Commands.add('getElement', (selectorAlias) => {
  // selector types:
  // 'css selector'
  // { selector: 'tag.class', text: 'unique text of element' }
  // { text: 'unique text of element' }
  // { selector: 'css selector which returns a few elements', index: numberOfOurElement }
  // the last type is very useful when it's very difficult to create nice selector
  cy.log(`Retrieving element: ${selectorAlias}`);

  // selectors folder contains JSON files which represent different pages
  // page name = file name
  // For example: campaigns.analytics.contactResponsesPerHourChart element located in
  // campaigns.json file
  const fileName = selectorAlias.substring(0, selectorAlias.indexOf('.'));
  cy.fixture(`selectors/${fileName}`).then((selectors) => {
    const selectorObj = getValueByPath(selectors, selectorAlias);
    if (selectorObj === undefined) {
      throw Error(`Can't find ${selectorAlias} element in ${fileName}.json`);
    }
    if (typeof selectorObj === 'object') {
      if ('getParent' in selectorObj) {
        return cy.get(selectorObj.selector).parent();
      }
      if ('getPrevious' in selectorObj) {
        return cy.get(selectorObj.selector).prev();
      }
      if ('index' in selectorObj) {
        return cy.get(selectorObj.selector).eq(selectorObj.index);
      }
      if ('selector' in selectorObj) {
        return cy.contains(selectorObj.selector, selectorObj.text);
      }
      return cy.contains(selectorObj.text);
    }
    return cy.get(selectorObj);
  });
});

Cypress.Commands.add('containsElement', (selectorAlias, text) => {
  cy.log(`Retrieving element: ${selectorAlias}`);
  // eslint-disable-next-line no-eval
  const fileName = selectorAlias.substring(0, selectorAlias.indexOf('.'));
  cy.fixture(`selectors/${fileName}`).then((selectors) => {
    return cy.contains(getValueByPath(selectors, selectorAlias), text);
  });
});
