import {And} from 'cypress-cucumber-preprocessor/steps';
import {convertDataTableIntoDict} from '../../support/utils';

And('Enable Inquiry Form', (datatable) => {
  const inquiryFormData = convertDataTableIntoDict(datatable);

  // enable if not enabled
  cy.contains('span', 'Edit').click();
  cy.get('#leadCaptureEnabled')
    .invoke('attr', 'value')
    .then((value) => {
      if (value === false) {
        cy.get('#leadCaptureEnabled').click();
      }
    });

  // setting values to checkboxes
  const CHECKBOXES = [
    'name',
    'email',
    'phone',
    'birthdate',
    'campus',
    'enrollment',
    'studentId',
    'studentType',
    'primaryInterest',
    'entryYear',
    'newOrTransfer',
    'source',
    'financialAid',
    'location',
    'citizenship',
    'textMessaging',
  ];
  const EMAIL_CHECKBOXES = ['DailyDigest', 'Immediately'];
  const checkedClass = 'Mui-checked';

  cy.wrap(CHECKBOXES.concat(EMAIL_CHECKBOXES)).each((checkboxName) => {
    const attrName = EMAIL_CHECKBOXES.includes(checkboxName) ? 'value' : 'name';
    const checkboxSelector = `input[${attrName}=${checkboxName}]`;
    cy.get(checkboxSelector)
      .parents('.MuiCheckbox-root')
      .invoke('attr', 'class')
      .then((classes) => {
        const isChecked = classes.includes(checkedClass);
        const setToChecked = Object.prototype.hasOwnProperty.call(inquiryFormData, checkboxName)
          && inquiryFormData[checkboxName] === 'checked';

        if ((!isChecked && setToChecked) || (isChecked && !setToChecked)) {
          cy.get(checkboxSelector).click();
        }
      });
  });

  // ToDo: Set email

  cy.contains('span', 'Save').click();
  const successBanner = 'div[aria-describedby="notistack-snackbar"]';
  cy.get(successBanner).should('exist');
});