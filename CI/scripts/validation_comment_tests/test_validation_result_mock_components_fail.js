const deploymentResult = {
  "status": 1,
  "result": {
    "checkOnly": true,
    "completedDate": "2024-12-20T08:15:35.000Z",
    "createdBy": "0052y000000XAvZ",
    "createdByName": "Andrew Kohanovskij",
    "createdDate": "2024-12-20T08:15:34.000Z",
    "details": {
      "componentFailures": [
        {
          "changed": false,
          "columnNumber": 5,
          "componentType": "ApexClass",
          "created": false,
          "createdDate": "2024-12-20T08:15:34.000Z",
          "deleted": false,
          "fileName": "classes/SomeClass.cls",
          "fullName": "SomeClass",
          "lineNumber": 4,
          "problem": "Missing ';' at '}'",
          "problemType": "Error",
          "success": false
        },{
          "changed": false,
          "columnNumber": 5,
          "componentType": "ApexClass",
          "created": false,
          "createdDate": "2024-12-20T08:15:34.000Z",
          "deleted": false,
          "fileName": "classes/SomeClass.cls",
          "fullName": "SomeClass",
          "lineNumber": 4,
          "problem": "Missing ';' at '}'",
          "problemType": "Error",
          "success": false
        }
      ],
      "componentSuccesses": [
        {
          "changed": true,
          "componentType": "",
          "created": false,
          "createdDate": "2024-12-20T08:15:34.000Z",
          "deleted": false,
          "fileName": "package.xml",
          "fullName": "package.xml",
          "success": true
        },
        {
          "changed": true,
          "componentType": "ApexClass",
          "created": true,
          "createdDate": "2024-12-20T08:15:34.000Z",
          "deleted": false,
          "fileName": "classes/SomeClassTest.cls",
          "fullName": "SomeClassTest",
          "id": "01pIi000000Gtz3IAC",
          "success": true
        }
      ],
      "runTestResult": {
        "numFailures": 0,
        "numTestsRun": 0,
        "totalTime": 0,
        "codeCoverage": [],
        "codeCoverageWarnings": [],
        "failures": [],
        "flowCoverage": [],
        "flowCoverageWarnings": [],
        "successes": []
      }
    },
    "done": true,
    "id": "0AfIi000000oo38KAA",
    "ignoreWarnings": false,
    "lastModifiedDate": "2024-12-20T08:15:35.000Z",
    "numberComponentErrors": 1,
    "numberComponentsDeployed": 1,
    "numberComponentsTotal": 2,
    "numberTestErrors": 0,
    "numberTestsCompleted": 0,
    "numberTestsTotal": 0,
    "rollbackOnError": true,
    "runTestsEnabled": true,
    "startDate": "2024-12-20T08:15:34.000Z",
    "status": "Failed",
    "success": false,
    "files": [
      {
        "fullName": "SomeClass",
        "type": "ApexClass",
        "state": "Failed",
        "problemType": "Error",
        "filePath": "/Users/andreikakhanouski/Job/test-git-actions/force-app/main/default/classes/SomeClass.cls",
        "lineNumber": 4,
        "columnNumber": 5,
        "error": "Missing ';' at '}' (4:5)"
      },
      {
        "fullName": "SomeClassTest",
        "type": "ApexClass",
        "state": "Created",
        "filePath": "/Users/andreikakhanouski/Job/test-git-actions/force-app/main/default/classes/SomeClassTest.cls"
      },
      {
        "fullName": "SomeClassTest",
        "type": "ApexClass",
        "state": "Created",
        "filePath": "/Users/andreikakhanouski/Job/test-git-actions/force-app/main/default/classes/SomeClassTest.cls-meta.xml"
      }
    ],
    "zipSize": 1376,
    "zipFileCount": 5,
    "deployUrl": "https://libak-dev-ed.my.salesforce.com/lightning/setup/DeployStatus/page?address=%2Fchangemgmt%2FmonitorDeploymentsDetails.apexp%3FasyncId%3D0AfIi000000oo38KAA%26retURL%3D%252Fchangemgmt%252FmonitorDeployment.apexp"
  },
  "warnings": []
}

const fs = require('fs');
fs.writeFileSync(
    "CI/scripts/validation_comment_tests/test_validation_result_mock_components_fail.md",
    require('../validation_comment.js')(deploymentResult)
);