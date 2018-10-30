import { API, Auth } from 'aws-amplify';

class APIService {
  endpoints = {
    config: '/config',
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
    return APIService
      .getAPIInit()
      .then(init => API.get(this.apiName, this.endpoints.config, init));
  }
}

export default APIService;
