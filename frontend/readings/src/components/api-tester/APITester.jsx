import React from 'react';
import APIService from '../../services/APIService';
import './APITester.css';

class APITester extends React.Component {
  state = {
    value: 'make API calls at the press of a button',
  }

  handleClick = () => {
    const api = new APIService();
    api.getConfig().then((response) => {
      console.log('api response', response);
      this.setState({ value: JSON.stringify(response, null, 2) });
    });
  }

  render() {
    const { value } = this.state;

    return (
      <div className="container">
        <div className="flex-container">
          <div className="panel">
            <button type="button" onClick={this.handleClick}>
              API Fetch
            </button>
          </div>
          <div className="panel">
            <textarea value={value} readOnly className="textArea" />
          </div>
        </div>
      </div>
    );
  }
}

export default APITester;
