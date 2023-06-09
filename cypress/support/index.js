// ***********************************************************
// This example support/index.js is processed and
// loaded automatically before your test files.
//
// This is a great place to put global configuration and
// behavior that modifies Cypress.
//
// You can change the location of this file or turn off
// automatically serving support files with the
// 'supportFile' configuration option.
//
// You can read more here:
// https://on.cypress.io/configuration
// ***********************************************************

// Import commands.js using ES2015 syntax:
import './client_admin_commands';
import './chatbot_api_commands';
import './selectors';
import './commands';
import './create_content_commands';
import './drupal_api_commands';
import 'cypress-mailosaur';

// Alternatively you can use CommonJS syntax:
// require('./commands')
