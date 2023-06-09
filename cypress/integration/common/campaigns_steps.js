import { And } from 'cypress-cucumber-preprocessor/steps';
import {convertDataTableIntoDict, extractBotHomePageUrl, validateInputParamsAccordingToDict} from '../../support/utils';

const BINARY_CONTENT_TYPE = 'binary';

And('Create campaign from template', (datatable) => {
  const inputData = datatable.rawTable[1];
  cy.replacePlaceholderAndSaveAs(inputData[0], 'campaignName');
  cy.replacePlaceholderAndSaveAs(inputData[1], 'templateName');
  cy.replacePlaceholderAndSaveAs(inputData[2], 'contactListName');

  cy.openCreateCampaignModal();
  cy.getElement('createContent.campaigns.createFromTemplate').click();
  // ToDo: use parameter
  cy.getElement('createContent.campaigns.admissions').click();

  cy.get('@DRUPAL_URL').then((drupalUrl) => {
    cy.intercept(`${drupalUrl}graphql*`).as('graphQl');
  });

  cy.get('@templateName').then((templateName) => {
    cy.getElement('createContent.campaigns.searchInput').type(templateName).type('{enter}');
  });

  cy.wait('@graphQl');

  cy.getElement('createContent.campaigns.addTemplateButton').click();

  cy.get('@contactListName').then((contactListName) => {
    cy.getElement('createContent.campaigns.searchInput').type(contactListName).type('{enter}');
  });

  cy.getElement('createContent.campaigns.addContactListButton').click();

  cy.get('@campaignName').then((campaignName) => {
    cy.getElement('createContent.campaigns.campaignTitleInput').type(campaignName);
  });

  cy.getElement('createContent.campaigns.сampusOfficeDropdown').click();
  cy.getElement('createContent.campaigns.firstOfficeItem').click();
  cy.getElement('createContent.campaigns.saveCampaignButton').click();
});

And('Create campaign', (datatable) => {
  const campaignData = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    createFrom: ['scratch', 'library', 'previous'],
    contentType: ['simple', BINARY_CONTENT_TYPE],
    message: 'any',
    campaignName: 'any',
    campaignType: ['bot', 'agent'],
    automaticArchive: ['1 day', '2 day', '3 day', '4 day'],
    number: 'any',
    office: 'any'
  };
  validateInputParamsAccordingToDict(campaignData, requiredParametersAndAcceptableValues);
  cy.task('log', `Creating campaign ${campaignData.campaignName}`);

  cy.openCreateCampaignModal();
  cy.wrap(campaignData).then((data) => {
    let selector;
    switch (data.createFrom.toLowerCase()) {
    case 'library':
    case 'previous':
      throw Error('Not implemented');
    case 'scratch':
      selector = 'createContent.campaigns.createFromScratch';
      break;
    }
    cy.getElement(selector).click();
  });

  // selecting contact list
  cy.intercept(`${Cypress.env('GRAPHQL_URL')}graphql`).as('searchRequest');
  cy.getElement('createContent.campaigns.searchInput')
    .type(campaignData.contactList)
    .type('{enter}');
  cy.wait('@searchRequest');
  cy.get(`[aria-label*='Use ${campaignData.contactList}']`).click();

  cy.replacePlaceholder(campaignData.campaignName).then((campaignName) => {
    cy.getElement('createContent.campaigns.campaignTitleInput').type(campaignName);
  });

  cy.getElement('createContent.campaigns.сampusOfficeDropdown').click();
  cy.contains('span', campaignData.office).click();

  cy.replacePlaceholder(campaignData.message).then((message) => {
    cy.getElement('createContent.campaigns.messageInput').type(message);
  });

  cy.wrap(campaignData).then((data) => {
    if (data.contentType.toLowerCase() === BINARY_CONTENT_TYPE) {
      cy.contains('div', 'Simple message (Default)').click();
      cy.contains('span', 'Yes/No Question').click();
      cy.wait(3000);
    }
    if (
      data.escalateYesResponse !== undefined &&
      ['yes', 'true'].includes(data.escalateYesResponse.toLowerCase())
    ) {
      cy.get('#needs-attention-label-YesResponses').click();
    }
    if (
      data.escalateNoResponse !== undefined &&
      ['yes', 'true'].includes(data.escalateNoResponse.toLowerCase())
    ) {
      cy.get('#needs-attention-label-NoResponses').click();
    }
    if (campaignData.yesResponse !== undefined) {
      cy.replacePlaceholder(campaignData.yesResponse).then((yesResponse) => {
        cy.getElement('createContent.campaigns.yesResponse').type(yesResponse);
      });
    }
    if (campaignData.noResponse !== undefined) {
      cy.replacePlaceholder(campaignData.noResponse).then((noResponse) => {
        cy.getElement('createContent.campaigns.noResponse').type(noResponse);
      });
    }
  });

  cy.wait(2000);
  cy.getElement('createContent.campaigns.saveCampaignButton').click();

  // launch campaign page
  cy.contains('span', 'Launch').should('exist');
  cy.wrap(campaignData).then((data) => {
    if (data.campaignType) {
      cy.get('#campaignType').click();
      cy.contains('[aria-labelledby="campaignType-label"]>li', data.campaignType).click();
    }
    if (data.idkType) {
      cy.get('#idkType').click();
      cy.contains('[aria-labelledby="idkType-label"]>li', data.idkType).click();
    }
    if (data.automaticArchive) {
      cy.get('#autoArchiveScheduleDays').click();
      cy.contains('li', data.automaticArchive).click();
    }
  });
  cy.replacePlaceholder(campaignData.number).then((provisionNumber) => {
    cy.get(`[aria-label="${provisionNumber}"]`).eq(1).click();
  });
  cy.contains('button', 'Launch').click();
  cy.contains('button', 'Confirm').click();
  cy.checkNotificationMessage('Campaign launched');
});

And('Archive campaign {string}', (campaignName) => {
  cy.url().then((currentUrl) => {
    cy.replacePlaceholder(campaignName).then((campaign) => {
      const botHomePage = extractBotHomePageUrl(currentUrl);
      cy.visit(`${botHomePage}/campaigns/active?keywords=${campaign}`);
    });
  });
  cy.get('button.MuiButton-containedSizeSmall').eq(1).click();
  cy.getElement('createContent.campaigns.archiveButtonSelector').click({force:true});
  cy.get('button').contains('Confirm').click();
});

And('Select available Phone number from phone number list', () => {
  cy.get('table[aria-label="Reusable Phone Number Picker"]>tbody>tr>td').eq(0).click();
});

And('Get Phone Number the opted out contact', () => {
  //ToDo: refactor this step
  cy.get('thead th span').each((el, index) => {
    if(el.text() === 'Phone Number'){
      const phnIndex = index + 2;
      cy.get('tbody tr:nth-child(1) td:nth-child(' + phnIndex + ')').then((phn) => {
        cy.wrap(phn.text()).as('phoneNumber');
      });
    }
  });
});

And('Optout first contact if opted-In', () => {
  //ToDo: refactor this step
  const firstRow = 'tbody>tr:nth-child(1)';
  cy.get(firstRow).then((row) => {
    if(row.find('path[d*="M7"]').length === 0) {
      cy.log('Contact already opted out');
    } else {
      cy.wrap(row.find('path[d*="M7"]')).click();
      cy.get('div.MuiDialogActions-root button[class*="Primary"]').click();
      cy.checkNotificationMessage('Contact opted-out');
    }
  });
});

And('Archive campaign which uses {string} number', (number) => {
  cy.openMenuItem('Texting->Phone Numbers');
  cy.replacePlaceholder(number).then((provisionNumber) => {
    cy.get('[name="keywords"]').type(provisionNumber).type('{enter}');
    // waiting for search results
    const provisionNumberFirstRow = 'tbody>tr:nth-child(1)>td>div';
    cy.get(provisionNumberFirstRow).should('have.text', provisionNumber);
  });

  const cellWithCampaignName = 'tbody>tr:nth-child(1)>td:nth-child(7)';
  cy.get(cellWithCampaignName).then((cell) => {
    const campaignName = cell.text();
    if (campaignName.length > 1) {
      cy.log(`Archiving campaign: ${campaignName}`);
      cy.get('@currentChatbot').then((chatbotName) => {
        cy.openChatbot(chatbotName);
      });
      cy.url().then((currentUrl) => {
        const botHomePage = extractBotHomePageUrl(currentUrl);
        cy.visit(`${botHomePage}/campaigns/active?keywords=${campaignName}`);
      });
      const campaignOptionsButtonSelector = 'div>button.MuiButton-containedSizeSmall:nth-child(2)';
      cy.get(campaignOptionsButtonSelector).click();
      cy.getElement('createContent.campaigns.archiveButtonSelector').click({force:true});
      cy.get('button').contains('Confirm').click({force: true});
    } else {
      cy.log('Provision number isnt in use.');
    }
  });
  cy.visit('/');
});

And('Verify that element {string} has phone number', (element) => {
  cy.getElement(element).invoke('text').then((phoneText) => {
    const phoneRegex = /^[+]?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$/im;
    expect(phoneRegex.test(phoneText)).to.eq(true,`Extracted phone number: ${phoneText}`);
  });
});

And('Update campaign', (datatable) => {
  const campaignData = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    campaignName: 'any',
    message: 'any',
    automaticArchive: ['1 day', '2 day', '3 day', '4 day'],
  };
  validateInputParamsAccordingToDict(campaignData, requiredParametersAndAcceptableValues);
  cy.replacePlaceholder(campaignData.campaignName).then((campaignName) => {
    cy.getElement('createContent.campaigns.campaignName').clear().type(campaignName);
  });

  cy.replacePlaceholder(campaignData.message).then((message) => {
    cy.getElement('createContent.campaigns.responseMessage').clear().type(message);
  });

  cy.replacePlaceholder(campaignData.automaticArchive).then((automaticArchive) => {
    cy.get('#autoArchiveScheduleDays').click();
    cy.contains('li', automaticArchive).click();
  });

  cy.getElement('createContent.campaigns.saveAsDraft').click();
  cy.checkNotificationMessage('Campaign draft saved');
});
