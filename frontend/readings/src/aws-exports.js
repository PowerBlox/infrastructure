const AWSConfig = {
  Auth: {
    mandatorySignIn: true,
    region: 'eu-west-1',
    userPoolId: 'eu-west-1_iPUYXLZ3L',
    userPoolWebClientId: '5mef3066aqmst4m5oj9gvip234',
  },
  API: {
    endpoints: [{
      name: 'APIGateway',
      endpoint: 'https://pdbi2eofs7.execute-api.eu-west-1.amazonaws.com/dev',
    }],
  },
};

export default AWSConfig;
