const deploymentValidation = ({
    status,
    result,
    warnings
}) => {
    const testFailureMessage = buildTestFailureString(
        result.details.runTestResult.failures
    );
    const componentsFailureMessage = buildComponentsFailureString(
        result.details.componentFailures
    );

    return buildMessageString(
        status,
        testFailureMessage,
        componentsFailureMessage
    );
};

const buildTestFailureString = testFailures => {
    return testFailures && testFailures.length && testFailures.reduce((result, failure) => {
        result += `
\t\tTest Class: ${failure.name}
\t\tTest Method: ${failure.methodName}
\t\tMessage: ${failure.message}
\t\tStackTrace: ${failure.stackTrace.replace(/\n/g, '\n\t\t')}
`;
        return result;
    }, '\n')
}

const buildComponentsFailureString = componentFailures => {
    return componentFailures && componentFailures.length && componentFailures.reduce((result, failure) => {
        result += `
\t\tType: ${failure.componentType}
\t\tName: ${failure.fullName}
\t\t${failure.problemType}: ${failure.problem}
\t\tLine: ${failure.lineNumber}
`;
        return result;
    }, '\n')
}

const buildMessageString = (statusCode, testResultStr, componentsFailureMessage) => {
    let message = `### ${!statusCode ? '💚' : '💔'} Deployment Validation Results:`;
        message += `\n- **Status**: ${!statusCode && 'Success' || 'Failed'}`;
        message += testResultStr 
            ? '\n- **Test Failures**:' + testResultStr 
            : '';
        message += componentsFailureMessage 
            ? '\n- **Component Failures**:' + componentsFailureMessage 
            : '';
    return message
}

module.exports = deploymentValidation;

