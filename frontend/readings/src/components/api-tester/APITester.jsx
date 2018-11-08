import React from 'react';
import APIService from '../../services/APIService';
import './APITester.css';

class APITester extends React.Component {
  state = {
    value: 'make API calls at the press of a button',
    loading: false,
    deviceId: '',
  }

  clickEchoVars = () => {
    this.setState({ loading: true });
    const api = new APIService();
    api.echoVars().then((response) => {
      this.setState({
        value: JSON.stringify(response, null, 2),
        loading: false,
        deviceId: '',
      });
    }).catch(() => {
      this.setState({
        value: 'error while reading from the api',
        loading: false,
        deviceId: '',
      });
    });
  }

  clickGetDevices = () => {
    this.setState({ loading: true });
    const api = new APIService();
    api.devices().then((response) => {
      this.setState({
        value: JSON.stringify(response, null, 2),
        loading: false,
        deviceId: '',
      });
    }).catch(() => {
      this.setState({
        value: 'error while reading from the api',
        loading: false,
        deviceId: '',
      });
    });
  }

  clickGetReadings = () => {
    this.setState({ loading: true });
    const { deviceId } = this.state;
    if (deviceId.length) {
      const api = new APIService();
      api.readings(deviceId).then((response) => {
        this.setState({
          value: JSON.stringify(response, null, 2),
          loading: false,
          deviceId: '',
        });
      }).catch(() => {
        this.setState({
          value: 'error while reading from the api',
          loading: false,
          deviceId: '',
        });
      });
    } else {
      this.setState({ value: 'you need to enter a device ID: get the list of devices first, then enter one of the available id as listed in the response' });
    }
  }

  changeDeviceId = (event) => {
    this.setState({ deviceId: event.target.value });
  }

  render() {
    const { value, deviceId, loading } = this.state;

    return (
      <div className="container">
        <div className="flex-container">
          <div className="panel">
            <button type="button" onClick={this.clickEchoVars}>
              Echo Vars
            </button>
            <br />
            <button type="button" onClick={this.clickGetDevices}>
              Get Devices
            </button>
            <br />
            <input type="text" value={deviceId} onChange={this.changeDeviceId} />
            <button type="button" onClick={this.clickGetReadings}>
              Get Readings
            </button>
            <br />
            { loading
              ? 'loading from API'
              : ''
            }
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
