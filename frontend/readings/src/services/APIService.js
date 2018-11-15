import { API, Auth } from 'aws-amplify';

class APIService {
  endpoints = {
    config: '/config',
    echo_vars: '/echo_vars',
    devices: '/devices',
    raw: '/raw',
    readings: '/readings',
  }

  static getAuthHeaders() {
    // returns promise of an object with authorization header
    return Auth
      .currentSession()
      .then(session => ({ Authorization: session.idToken.jwtToken }))
      .catch(error => console.log('get auth headers', error));
  }

  static getAPIInit() {
    // returns promise of an object that can be used to initialise the api call
    return APIService
      .getAuthHeaders()
      .then(headers => ({ headers: Object.assign({}, headers), response: true }));
  }

  constructor() {
    this.apiName = 'APIGateway';
  }

  getConfig() {
    // currently not implemented, will return a 404
    return APIService
      .getAPIInit()
      .then(init => API.get(this.apiName, this.endpoints.config, init));
  }

  echoVars() {
    return APIService
      .getAPIInit()
      .then(init => API.get(this.apiName, this.endpoints.echo_vars, init));
  }

  devices() {
    return APIService
      .getAPIInit()
      .then(init => API.get(this.apiName, this.endpoints.devices, init));
  }

  raw() {
    return APIService
      .getAPIInit()
      .then(init => API.get(this.apiName, this.endpoints.raw, init));
  }

  readings(deviceId) {
    return APIService
      .getAPIInit()
      .then(init => API.get(this.apiName, `${this.endpoints.readings}/${deviceId}`, init));
  }
}

export default APIService;
