import React from 'react';
import ReactDOM from 'react-dom';
import Amplify from 'aws-amplify';
import resources from './aws-resources.dev';
import './index.css';
import App from './App';
import * as serviceWorker from './serviceWorker';

const AWSConfig = {
  Auth: {
    mandatorySignIn: true,
    region: resources.region,
    userPoolId: resources.userPoolId,
    userPoolWebClientId: resources.userPoolWebClientId,
  },
  API: {
    endpoints: [{
      name: 'APIGateway',
      endpoint: resources.endpoint,
    }],
  },
};

Amplify.configure(AWSConfig);

ReactDOM.render(<App />, document.getElementById('root'));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: http://bit.ly/CRA-PWA
serviceWorker.unregister();
