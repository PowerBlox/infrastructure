import React from 'react';
import { withAuthenticator } from 'aws-amplify-react';
import APITester from './components/api-tester/APITester';

import './App.css';

const App = () => {
  const app = (
    <div className="App">
      <APITester />
    </div>
  );
  return app;
};

export default withAuthenticator(App, true);
