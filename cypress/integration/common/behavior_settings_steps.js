import {And} from 'cypress-cucumber-preprocessor/steps';
import {convertDataTableIntoDict, validateInputParamsAccordingToDict} from '../../support/utils';

const successBannerSelector = 'div[aria-describedby="notistack-snackbar"]';
const saveButtonSelector = 'button.MuiButton-containedPrimary';
const checkedClass = 'Mui-checked';

And('Set IDK settings', (datatable) => {
  const behaviorSettingsData = convertDataTableIntoDict(datatable);

  const requiredParametersAndAcceptableValues = {
    behaviorSettings: ['contact form', 'custom response'],
    message: 'any'
  };
  validateInputParamsAccordingToDict(behaviorSettingsData, requiredParametersAndAcceptableValues);

  cy.contains('button', 'Edit').click();
  cy.wrap(behaviorSettingsData).then((data) => {
    const behaviorDropDown = 'div.MuiOutlinedInput-input';
    const responseInputSelector = '[role="textbox"]';
    cy.get(behaviorDropDown).eq(2).click();
    cy.contains('li.MuiMenuItem-root', data.behaviorSettings).click();
    if (data.behaviorSettings === 'Contact Form') {
      const contactEmailInputSelector = 'div>input[type="email"]';
      const phoneCheckboxSelector = 'input[value="phone"]';
      const studentIdCheckboxSelector = 'input[value="student_id"]';

      cy.get(phoneCheckboxSelector)
        .parents('.MuiCheckbox-root')
        .invoke('attr', 'class')
        .then((classes) => {
          const isChecked = classes.includes(checkedClass);
          const setToChecked = data.phone && data.phone === 'checked';
          if ((!isChecked && setToChecked) || (isChecked && !setToChecked)) {
            cy.get(phoneCheckboxSelector).click();
          }
        });

      cy.get(studentIdCheckboxSelector)
        .parents('.MuiCheckbox-root')
        .invoke('attr', 'class')
        .then((classes) => {
          const isChecked = classes.includes(checkedClass);
          const setToChecked = data.studentId && data.studentId === 'checked';
          if ((!isChecked && setToChecked) || (isChecked && !setToChecked)) {
            cy.get(studentIdCheckboxSelector).click();
          }
        });

      cy.get('body').then((body) => {
        const isEmailAlreadyAdded = body
          .find('span.MuiChip-label')
          .filter((index, elt) => { return elt.innerText.includes(data.email); })
          .length > 0;
        if (!isEmailAlreadyAdded) {
          cy.log(`Adding IDK contact email: ${data.email}`);
          cy.get(contactEmailInputSelector).type(data.email).type('{enter}');
        } else {
          cy.log(`IDK contact email: ${data.email} already present`);
        }
      });
      cy.get(responseInputSelector).clear().type(data.message);
    }

    if (data.behaviorSettings === 'Custom Response') {
      cy.replacePlaceholder(data.message).then((customResponse) => {
        cy.get(responseInputSelector).clear().type(customResponse);
      });
    }

    cy.get(saveButtonSelector).click();
    cy.get(successBannerSelector).should('exist');
  });
});

And('Enable Inquiry Form', (datatable) => {
  const inquiryFormData = convertDataTableIntoDict(datatable);

  // enable if not enabled
  cy.contains('button', 'Edit').click();
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
  cy.get(saveButtonSelector).click();
  cy.get(successBannerSelector).should('exist');
});