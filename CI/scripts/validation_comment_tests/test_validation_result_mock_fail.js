const deploymentResult = {
    "status": 1,
    "result": {
        "checkOnly": true,
        "completedDate": "2024-12-19T23:01:02.000Z",
        "createdBy": "0052y000000XAvZ",
        "createdByName": "Andrew Kohanovskij",
        "createdDate": "2024-12-19T23:01:00.000Z",
        "details": {
            "componentSuccesses": [{
                    "changed": true,
                    "componentType": "ApexClass",
                    "created": true,
                    "createdDate": "2024-12-19T23:01:01.000Z",
                    "deleted": false,
                    "fileName": "classes/SomeClass.cls",
                    "fullName": "SomeClass",
                    "id": "01pIi000000GtwnIAC",
                    "success": true
                },
                {
                    "changed": true,
                    "componentType": "",
                    "created": false,
                    "createdDate": "2024-12-19T23:01:01.000Z",
                    "deleted": false,
                    "fileName": "package.xml",
                    "fullName": "package.xml",
                    "success": true
                },
                {
                    "changed": true,
                    "componentType": "ApexClass",
                    "created": true,
                    "createdDate": "2024-12-19T23:01:01.000Z",
                    "deleted": false,
                    "fileName": "classes/SomeClassTest.cls",
                    "fullName": "SomeClassTest",
                    "id": "01pIi000000GtwoIAC",
                    "success": true
                }
            ],
            "runTestResult": {
                "codeCoverage": [{
                        "id": "01pIi000000GtwnIAC",
                        "locationsNotCovered": [{
                                "column": 0,
                                "line": 2,
                                "numExecutions": 0,
                                "time": -1
                            },
                            {
                                "column": 0,
                                "line": 6,
                                "numExecutions": 0,
                                "time": -1
                            }
                        ],
                        "name": "SomeClass",
                        "namespace": null,
                        "numLocations": 2,
                        "numLocationsNotCovered": 2,
                        "type": "Class",
                        "dmlInfo": [],
                        "methodInfo": [],
                        "soqlInfo": [],
                        "soslInfo": []
                    },
                    {
                        "id": "01p2y000000NeREAA0",
                        "locationsNotCovered": [{
                            "column": 0,
                            "line": 15,
                            "numExecutions": 0,
                            "time": -1
                        }],
                        "name": "ForgotPasswordController",
                        "namespace": null,
                        "numLocations": 9,
                        "numLocationsNotCovered": 1,
                        "type": "Class",
                        "dmlInfo": [],
                        "methodInfo": [],
                        "soqlInfo": [],
                        "soslInfo": []
                    },
                    {
                        "id": "01p2y000000NeRCAA0",
                        "name": "ChangePasswordController",
                        "namespace": null,
                        "numLocations": 6,
                        "numLocationsNotCovered": 0,
                        "type": "Class",
                        "dmlInfo": [],
                        "locationsNotCovered": [],
                        "methodInfo": [],
                        "soqlInfo": [],
                        "soslInfo": []
                    },
                    {
                        "id": "01p2y000000NeR8AAK",
                        "name": "SiteLoginController",
                        "namespace": null,
                        "numLocations": 6,
                        "numLocationsNotCovered": 0,
                        "type": "Class",
                        "dmlInfo": [],
                        "locationsNotCovered": [],
                        "methodInfo": [],
                        "soqlInfo": [],
                        "soslInfo": []
                    },
                    {
                        "id": "01p2y000000NeRAAA0",
                        "locationsNotCovered": [{
                                "column": 0,
                                "line": 39,
                                "numExecutions": 0,
                                "time": -1
                            },
                            {
                                "column": 0,
                                "line": 40,
                                "numExecutions": 0,
                                "time": -1
                            },
                            {
                                "column": 0,
                                "line": 43,
                                "numExecutions": 0,
                                "time": -1
                            },
                            {
                                "column": 0,
                                "line": 44,
                                "numExecutions": 0,
                                "time": -1
                            },
                            {
                                "column": 0,
                                "line": 45,
                                "numExecutions": 0,
                                "time": -1
                            }
                        ],
                        "name": "SiteRegisterController",
                        "namespace": null,
                        "numLocations": 27,
                        "numLocationsNotCovered": 5,
                        "type": "Class",
                        "dmlInfo": [],
                        "methodInfo": [],
                        "soqlInfo": [],
                        "soslInfo": []
                    },
                    {
                        "id": "01p2y000000NeRGAA0",
                        "locationsNotCovered": [{
                                "column": 0,
                                "line": 21,
                                "numExecutions": 0,
                                "time": -1
                            },
                            {
                                "column": 0,
                                "line": 37,
                                "numExecutions": 0,
                                "time": -1
                            },
                            {
                                "column": 0,
                                "line": 38,
                                "numExecutions": 0,
                                "time": -1
                            }
                        ],
                        "name": "MyProfilePageController",
                        "namespace": null,
                        "numLocations": 24,
                        "numLocationsNotCovered": 3,
                        "type": "Class",
                        "dmlInfo": [],
                        "methodInfo": [],
                        "soqlInfo": [],
                        "soslInfo": []
                    }
                ],
                "failures": [{
                    "id": "01pIi000000GtwoIAC",
                    "message": "System.AssertException: Assertion Failed",
                    "methodName": "methodName",
                    "name": "SomeClassTest",
                    "namespace": null,
                    "packageName": "SomeClassTest",
                    "stackTrace": "External entry point\nClass.SomeClassTest.methodName: line 7, column 1",
                    "time": 95,
                    "type": "Class"
                },{
                    "id": "01pIi000000GtwoIAC",
                    "message": "System.AssertException: Assertion Failed",
                    "methodName": "methodName",
                    "name": "SomeClassTest",
                    "namespace": null,
                    "packageName": "SomeClassTest",
                    "stackTrace": "External entry point\nClass.SomeClassTest.methodName: line 7, column 1",
                    "time": 95,
                    "type": "Class"
                }],
                "numFailures": 1,
                "numTestsRun": 6,
                "successes": [{
                        "id": "01p2y000000NeRDAA0",
                        "methodName": "testChangePasswordController",
                        "name": "ChangePasswordControllerTest",
                        "namespace": null,
                        "time": 139
                    },
                    {
                        "id": "01p2y000000NeRFAA0",
                        "methodName": "testForgotPasswordController",
                        "name": "ForgotPasswordControllerTest",
                        "namespace": null,
                        "time": 51
                    },
                    {
                        "id": "01p2y000000NeR9AAK",
                        "methodName": "testSiteLoginController",
                        "name": "SiteLoginControllerTest",
                        "namespace": null,
                        "time": 51
                    },
                    {
                        "id": "01p2y000000NeRBAA0",
                        "methodName": "testRegistration",
                        "name": "SiteRegisterControllerTest",
                        "namespace": null,
                        "time": 51
                    },
                    {
                        "id": "01p2y000000NeRHAA0",
                        "methodName": "testSave",
                        "name": "MyProfilePageControllerTest",
                        "namespace": null,
                        "time": 219
                    }
                ],
                "totalTime": 711,
                "codeCoverageWarnings": [],
                "flowCoverage": [],
                "flowCoverageWarnings": []
            },
            "componentFailures": []
        },
        "done": true,
        "id": "0AfIi000000onyXKAQ",
        "ignoreWarnings": false,
        "lastModifiedDate": "2024-12-19T23:01:02.000Z",
        "numberComponentErrors": 0,
        "numberComponentsDeployed": 2,
        "numberComponentsTotal": 2,
        "numberTestErrors": 1,
        "numberTestsCompleted": 5,
        "numberTestsTotal": 6,
        "rollbackOnError": true,
        "runTestsEnabled": true,
        "startDate": "2024-12-19T23:01:00.000Z",
        "status": "Failed",
        "success": false,
        "files": [{
                "fullName": "SomeClass",
                "type": "ApexClass",
                "state": "Created",
                "filePath": "/Users/andreikakhanouski/Job/test-git-actions/force-app/main/default/classes/SomeClass.cls"
            },
            {
                "fullName": "SomeClass",
                "type": "ApexClass",
                "state": "Created",
                "filePath": "/Users/andreikakhanouski/Job/test-git-actions/force-app/main/default/classes/SomeClass.cls-meta.xml"
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
        "zipSize": 1430,
        "zipFileCount": 5,
        "deployUrl": "https://libak-dev-ed.my.salesforce.com/lightning/setup/DeployStatus/page?address=%2Fchangemgmt%2FmonitorDeploymentsDetails.apexp%3FasyncId%3D0AfIi000000onyXKAQ%26retURL%3D%252Fchangemgmt%252FmonitorDeployment.apexp"
    },
    "warnings": []
}

const fs = require('fs');
fs.writeFileSync(
    "CI/scripts/validation_comment_tests/test_validation_result_mock_fail.md",
    require('../validation_comment.js')(deploymentResult)
);