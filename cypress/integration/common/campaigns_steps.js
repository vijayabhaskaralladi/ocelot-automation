import { And } from 'cypress-cucumber-preprocessor/steps';
import { convertDataTableIntoDict } from '../../support/utils';

const archiveButtonSelector = '#split-button-menu>span:nth-child(2)>li';

And('Create campaign', (datatable) => {
  const inputData = datatable.rawTable[1];
  cy.replacePlaceholderAndSaveAs(inputData[0], 'campaignName');
  cy.replacePlaceholderAndSaveAs(inputData[1], 'templateName');
  cy.replacePlaceholderAndSaveAs(inputData[2], 'contactListName');

  cy.getElement('createContent.createContentMenuButton').click();
  cy.getElement('createContent.createCampaign').click();
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

And('Create binary campaign', (datatable) => {
  const campaignData = convertDataTableIntoDict(datatable);

  cy.getElement('createContent.createContentMenuButton').click();
  cy.getElement('createContent.createCampaign').click();
  cy.getElement('createContent.campaigns.createFromScratch').click();

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

  cy.contains('div', 'Simple message (Default)').click();
  cy.contains('span', 'Yes/No Question').click();
  cy.wait(3000);

  cy.replacePlaceholder(campaignData.message).then((message) => {
    cy.getElement('createContent.campaigns.messageInput').type(message);
  });

  cy.wrap(campaignData).then((data) => {
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
      cy.contains('li', data.campaignType).click();
    }
  });
  cy.replacePlaceholder(campaignData.number).then((provisionNumber) => {
    cy.get(`[aria-label="${provisionNumber}"]`).click();
  });
  cy.contains('span', 'Launch').click();
  cy.contains('span', 'Confirm').click();
});

And('Archive campaign {string}', (campaignName) => {
  cy.url().then((currentUrl) => {
    cy.replacePlaceholder(campaignName).then((campaign) => {
      cy.visit(`${currentUrl}/campaigns/active?keywords=${campaign}`);
    });
  });
  cy.get('button.MuiButton-containedSizeSmall').eq(1).click();
  cy.get(archiveButtonSelector).click();
  cy.get('span').contains('Confirm').click();
});

And('Select available Phone number from phone number list', () => {
  cy.get('table[aria-label="Reusable Phone Number Picker"]>tbody>tr>td').eq(0).click();
});

And('Get the opted out the PhoneNumber and EMail', () => {
  cy.get('thead th span').each((el, index) => {
    if(el.text() === 'Email Address'){
      const emailIndex = index + 2;
      cy.get('tbody tr:nth-child(1) td:nth-child(' + emailIndex + ')').then((mail) => {
        cy.wrap(mail.text()).as('email');
      });
    }
    if(el.text() === 'Phone Number'){
      const phnIndex = index + 2;
      cy.get('tbody tr:nth-child(1) td:nth-child(' + phnIndex + ')').then((phn) => {
        cy.wrap(phn.text()).as('phnNumber');
      });
    }
  });
});

And('Optout first contact if opted-In', () => {
  cy.get('tbody.MuiTableBody-root tr:nth-child(1)').then(function(element1) {
    if(element1.find('path[d*="M7"]').length === 0) {
      cy.log('Contact already opted out');
    } else {
      cy.wrap(element1.find('path[d*="M7"]')).click();
      cy.get('button[class*="Primary"]').click();
    }
  });
});

And('Archive campaign which uses {string} number', (number) => {
  cy.openMenuItem('Campaigns->Phone Numbers');
  cy.intercept('POST', `${Cypress.env('GRAPHQL_URL')}graphql`).as('searchRequest');
  cy.replacePlaceholder(number).then((provisionNumber) => {
    cy.get('[name="keywords"]').type(provisionNumber).type('{enter}');
  });
  cy.wait('@searchRequest');

  const cellWithCampaignName = 'tbody>tr>td:nth-child(7)';
  cy.get(cellWithCampaignName).then((cell) => {
    const campaignName = cell.text();
    if (campaignName.length > 1) {
      cy.log(`Archiving campaign: ${campaignName}`);

      cy.get('@currentChatbot').then((chatbotName) => {
        cy.openChatbot(chatbotName);
      });
      cy.url().then((currentUrl) => {
        cy.visit(`${currentUrl}/campaigns/active?keywords=${campaignName}`);
      });
      const campaignOptionsButtonSelector = 'div>button.MuiButton-containedSizeSmall:nth-child(2)';
      cy.get(campaignOptionsButtonSelector).click();
      cy.get(archiveButtonSelector).click();
      cy.get('span').contains('Confirm').click();
    } else {
      cy.log(`Provision number isn't in use: ${number}`);
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
