module.exports = {
  'env': {
    'browser': true,
    'es2021': true,
    'node': true
  },
  'extends': 'eslint:recommended',
  'parserOptions': {
    'ecmaVersion': 'latest',
    'sourceType': 'module'
  },
  'rules': {
    'indent': [
      'error',
      2
    ],
    'linebreak-style': [
      'error',
      'unix'
    ],
    'quotes': [
      'error',
      'single'
    ],
    'semi': [
      'error',
      'always'
    ],
    'no-plusplus': ['error', {'allowForLoopAfterthoughts': true}],
    'no-console': 0,
    'no-var': 2,
    'max-len': ['error', {'code': 100}],
    'no-dupe-else-if': 2,
    'no-multiple-empty-lines': ['error', {'max': 1}]
  },
  'globals': {
    'cy': true,
    'Cypress': true,
    'assert': true,
    'expect': true
  }
};
