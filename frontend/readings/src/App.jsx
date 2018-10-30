import React from 'react';
import { withAuthenticator } from 'aws-amplify-react';

import logo from './logo.svg';
import './App.css';

const App = () => {
  const app = (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Oh, howdy!
        </p>
      </header>
    </div>
  );
  return app;
}

export default withAuthenticator(App, true);
