import React from 'react';
import APIService from '../../services/APIService';
import './APITester.css';

class APITester extends React.Component {
  state = {
    value: 'make API calls at the press of a button',
    deviceId: null,
  }

  clickEchoVars = () => {
    const api = new APIService();
    api.echoVars().then((response) => {
      this.setState({
        value: JSON.stringify(response, null, 2),
        deviceId: null,
      });
    });
  }

  clickGetDevices = () => {
    const api = new APIService();
    api.devices().then((response) => {
      this.setState({
        value: JSON.stringify(response, null, 2),
        deviceId: null,
      });
    });
  }

  clickGetReadings = () => {
    const { deviceId } = this.state;
    if (deviceId.length) {
      const api = new APIService();
      api.readings(deviceId).then((response) => {
        this.setState({
          value: JSON.stringify(response, null, 2),
          deviceId: null,
        });
      });
    } else {
      this.setState({ value: 'you need to enter a device ID first' });
    }
  }

  changeDeviceId = (event) => {
    this.setState({ deviceId: event.target.value });
  }

  render() {
    const { value, deviceId } = this.state;

    return (
      <div className="container">
        <div className="flex-container">
          <div className="panel">
            <button type="button" onClick={this.clickEchoVars}>
              Echo Vars
            </button>
            <button type="button" onClick={this.clickGetDevices}>
              Get Devices
            </button>
            <input type="text" value={deviceId} onChange={this.changeDeviceId} />
            <button type="button" onClick={this.clickGetReadings}>
              Get Readings
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
