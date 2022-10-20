import {And} from 'cypress-cucumber-preprocessor/steps';
import {convertDataTableIntoDict, validateInputParamsAccordingToDict} from '../../support/utils';

const isApplicationEnabled = (serviceStatusesResponse, application) => {
  const integrations = serviceStatusesResponse.body.data.getProvisionedIntegrations;
  return integrations
    .filter(item => item.type === application && item.status === 'Enabled')
    .length === 1;
};

And('Enable Service Now', (datatable) => {
  const serviceNowData = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    baseUrl: 'any',
    authToken: 'any',
    contextualEntity: 'any'
  };
  validateInputParamsAccordingToDict(serviceNowData, requiredParametersAndAcceptableValues);

  cy.replacePlaceholder(serviceNowData.authToken).then((token) => {
    cy.replacePlaceholder(serviceNowData.contextualEntity).then((contextualEntity) => {
      cy.getServicesStatuses(token, contextualEntity).then((response)=>{
        if (isApplicationEnabled(response, 'ServiceNow')) {
          cy.contains('h2', 'ServiceNow')
            .parent('div.MuiCardContent-root')
            .next()
            .contains('span', 'Configure')
            .click();
        } else {
          cy.contains('h2', 'ServiceNow')
            .parent('div.MuiCardContent-root')
            .next()
            .contains('span', 'Enable')
            .click();
        }
      });
    });

    const baseUrlInput = 'input[name="baseUri"]';
    cy.get(baseUrlInput).clear().type(serviceNowData.baseUrl);
    cy.contains('span','Save').click();
    cy.checkNotificationMessage('The configuration has been saved successfully!');
  });
});

And('Disable Service Now', (datatable) => {
  const requestTokens = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    authToken: 'any',
    contextualEntity: 'any'
  };
  validateInputParamsAccordingToDict(requestTokens, requiredParametersAndAcceptableValues);

  cy.replacePlaceholder(requestTokens.authToken).then((token) => {
    cy.replacePlaceholder(requestTokens.contextualEntity).then((contextualEntity) => {
      cy.getServicesStatuses(token, contextualEntity).then((response)=>{
        if (isApplicationEnabled(response, 'ServiceNow')) {
          cy.contains('h2', 'ServiceNow')
            .parent('div.MuiCardContent-root')
            .next()
            .contains('span', 'Disable')
            .click();
        }
      });
    });
  });
});

And('Enable Slate', (datatable) => {
  const slateData = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    baseSlateQuery: 'any',
    authToken: 'any',
    contextualEntity: 'any'
  };
  validateInputParamsAccordingToDict(slateData, requiredParametersAndAcceptableValues);

  cy.replacePlaceholder(slateData.authToken).then((token) => {
    cy.replacePlaceholder(slateData.contextualEntity).then((contextualEntity) => {
      cy.getServicesStatuses(token, contextualEntity).then((response)=>{
        if (!isApplicationEnabled(response, 'Slate')) {
          cy.contains('h2', 'Slate')
            .parent('div.MuiCardContent-root')
            .next()
            .contains('span', 'Enable')
            .click();
          //ToDo: this step doesn't fill Slate URLs,will be implemented later
          cy.contains(slateData).should('exist');
          cy.contains('span', 'Save').click();
          cy.checkNotificationMessage('The configuration has been saved successfully!');
        }
      });
    });
  });
});

And('Disable Slate', (datatable) => {
  const requestTokens = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    authToken: 'any',
    contextualEntity: 'any'
  };
  validateInputParamsAccordingToDict(requestTokens, requiredParametersAndAcceptableValues);

  cy.replacePlaceholder(requestTokens.authToken).then((token) => {
    cy.replacePlaceholder(requestTokens.contextualEntity).then((contextualEntity) => {
      cy.getServicesStatuses(token, contextualEntity).then((response)=>{
        if (isApplicationEnabled(response, 'Slate')) {
          cy.contains('h2', 'Slate')
            .parent('div.MuiCardContent-root')
            .next()
            .contains('span', 'Disable')
            .click();
        }
      });
    });
  });
});
