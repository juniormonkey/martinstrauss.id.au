// Copyright 2007 Google Inc.
// All Rights Reserved.

/**
 * @fileoverview
 * Utilities to help build applications using the OpenSocial APIs.
 *
 * @author uidude@google.com (Evan Gilbert)
 */


/**
 * Define the namespace.
 */
var SocialNorms = {};


/**
 * Create a social application that uses common data access patterns.
 * 
 * @param {Object} appImpl. Object with function callbacks to customize
 *   behavior of the application. render is the only current callback,
 *   see SocialNorms.AppImpl for descriptions of methods
 * @param {String} type Type of application, current options are OWNER,
 *   for apps that are installed on a page about a single person,
 *   and VIEWER, for apps that show information based on the currently
 *   logged in user.
 * @param {String|Array&ltString&gt} key Key(s) of app data fields to get
 *   for all people. No current way to specify different fields for owner,
 *   viewer, and friends. Will be optional once wildcard keys are supported.
 */
SocialNorms.createSocialApp = function(appImpl, type, keys) {
  return new SocialNorms.SocialApp(appImpl, type, keys);
};


/**
 * Create a social app on page load.
 * Stores the application in the window variable "theApp".
 * 
 * @param {Object} appImpl. See createSocialApp
 * @param {String} type  See createSocialApp
 * @param {String|Array&ltString&gt} key  See createSocialApp
 */
SocialNorms.createSocialAppOnLoad = function(appImpl, type, keys) {
  window['_IG_RegisterOnloadHandler'](function(){
    var app = SocialNorms.createSocialApp(appImpl, type, keys);
    window['theApp'] = app;
    app.start();
  });
};


/**
 * Definition of a class for customizing a social app.
 */
SocialNorms.AppImpl = function() {};


/**
 * Render HTML for the application.
 * 
 * @param {SocialNorms.SocialApp.Data} Data for rendering
 */
SocialNorms.AppImpl.render = function(data) {};


/**
 * A simple social application.
 * @constructor
 * @private
 */
SocialNorms.SocialApp = function(appImpl, type, keys) {
  this.appImpl = appImpl;
  this.type = type;
  this.keys = keys || [];
};


/**
 * Create the initial request for data, send it,
 * and render when this data is received.
 */
SocialNorms.SocialApp.prototype.start = function() {
  this.initialRequest = SocialNorms.Data.createRequestForCommonData(
      this.type, this.keys);
  this.sendInitialRequest();
};


/**
 * Send the initial data request.
 * @private
 */
SocialNorms.SocialApp.prototype.sendInitialRequest = function() {
  var me = this;
  this.initialRequest.send(function(dataResponse) {
    me.initialDataReceived(dataResponse);
  });
};


/**
 * Resend the initial data request and rerender when data returns.
 */
SocialNorms.SocialApp.prototype.resendInitialRequest = function() {
  this.sendInitialRequest();
};


/**
 * Callback when initial data is received.
 * 
 * @param {opensocial.DataResponse}
 * @private
 */
SocialNorms.SocialApp.prototype.initialDataReceived = function(dataResponse) {
  this.data = new SocialNorms.Data(dataResponse);
  this.render();
};


/**
 * Render the UI.
 */
SocialNorms.SocialApp.prototype.render = function() {
  this.appImpl.render(this.data);
};


/**
 * Data structure to hold data returned from opensocial
 * data APIs.
 * 
 * Currently only holds result of initial data request,
 * may be extended to support merges in additional data
 * returned from the server.
 * 
 * All data functions may return null if the data
 * was not retreived.
 * 
 * @param {opensocial.DataResponse} Response from opensocial data API
 * @constructor
 * @private
 */
SocialNorms.Data = function(dataResponse) {
  this.dataResponse = dataResponse;
  this.viewerId = this.getViewer() ? this.getViewer().getId() : null;
  this.ownerId = this.getOwner() ? this.getOwner().getId() : null;
};


/**
 * Create a request for the common set of data on a page:
 * owner, viewer, friends of either owner or viewer, app data for the same. 
 * 
 * @param {String} friendsOf Person to get friends of - either VIEWER or OWNER
 * @param {String|Array&ltString&gt} key Key(s) of app data fields to get
 * @return {opensocial.DataRequest} The request to send.
 * @private
 */
SocialNorms.Data.createRequestForCommonData = function(friendsOf, keys) {
  if (SocialNorms.isString(keys)) {
    keys = [keys];
  }
  
  var req = opensocial.newDataRequest();
  req.add(req.newFetchPersonRequest('OWNER'), 'o');
  req.add(req.newFetchPersonAppDataRequest('OWNER', keys), 'od');
  req.add(req.newFetchPersonRequest('VIEWER'), 'v');
  req.add(req.newFetchPersonAppDataRequest('VIEWER', keys), 'vd');
  if (friendsOf == 'OWNER') {
    req.add(req.newFetchPeopleRequest('OWNER_FRIENDS'), 'of');
    req.add(req.newFetchPersonAppDataRequest('OWNER_FRIENDS', keys), 'ofd');
  } else {
    req.add(req.newFetchPeopleRequest('VIEWER_FRIENDS'), 'vf');
    req.add(req.newFetchPersonAppDataRequest('VIEWER_FRIENDS', keys), 'vfd');
    
  }
  return req;
};


/**
 * Get the viewer.
 * @return {Person} The viewer.
 */
SocialNorms.Data.prototype.getViewer = function() {
  return this.getData('v');
};


/**
 * Get the owner.
 * @return {Person} The owner.
 */
SocialNorms.Data.prototype.getOwner = function() {
  return this.getData('o');
};


/**
 * Get the viewer's friends.
 * 
 * @return {Collection&ltPerson&gt} The viewer's friends
 */
SocialNorms.Data.prototype.getViewerFriends = function() {
  return this.getData('vf');
};


/**
 * Get the owner's friends.
 * 
 * @return {Collection&ltPerson&gt} The viewer's friends
 */
SocialNorms.Data.prototype.getOwnerFriends = function() {
  return this.getData('of');
};


/**
 * Get the app data for a given person.
 * 
 * 
 * @param {Person|String} person Person or ID of person to get data for.
 */
SocialNorms.Data.prototype.getDataFor = function(person) {
  var id = SocialNorms.getPersonId(person);
  if (id == 'VIEWER' || id == this.viewerId) {
    return this.getViewerData();
  } else if (id == 'OWNER' || id == this.ownerId) {
    return this.getOwnerData();
  } else {
    var friendsData = this.getData('ofd') || this.getData('vfd');
    return SocialNorms.getAppDataFor(friendsData, id); 
  }
};


/**
 * Get the owner's app data.
 * 
 * @return {Object} The app data.
 */
SocialNorms.Data.prototype.getOwnerData = function() {
  return SocialNorms.getAppDataFor(this.getData('od'));
};


/**
 * Get the viewer's app data.
 * 
 * @return {Object} The app data
 */
SocialNorms.Data.prototype.getViewerData = function() {
  return SocialNorms.getAppDataFor(this.getData('vd'));
};


/**
 * Get data from the response, given a key.
 * 
 * @param {String} key The key
 * @return {Object} The data
 */
SocialNorms.Data.prototype.getData = function(key) {
  var respItem = this.dataResponse.get(key);
  if (respItem == null) {
    return null;
  }
  
  return respItem.getData();
};


/**
 * Get a response item, given a key.
 * 
 * @param {String} key The key
 * @return {opensocial.ResponseItem} The response item
 */
SocialNorms.Data.prototype.getResponseItem = function(key) {
  return this.dataResponse.get(key);
};


/**
 * Set application data for a give person.
 * 
 * @param {Person|String} person Person or ID of person to set application
 *   data for.
 * @param {String} key Application data key
 * @param {Object} value Application data value
 * @param {Function} callback Optional function to call with dataResponse
 */
SocialNorms.setPersonData = function(person, key, value, callback) {
  var id = SocialNorms.getPersonId(person);
  var req = opensocial.newDataRequest();
  req.add(req.newUpdatePersonAppDataRequest(id, key, value));
  req.send(callback);
};


/**
 * Set instance data for the current application instance.
 * Will fail if the current user is not the owner of the application
 * instance.
 * 
 * @param {String} key Application data key
 * @param {Object} value Application data value
 * @param {Function} callback Optional function to call with dataResponse
 */
SocialNorms.setInstanceData = function(key, value, callback) {
  var req = opensocial.newDataRequest();
  req.add(req.newUpdateInstanceAppDataRequest(key, value));
  req.send(callback);
};


/**
 * Gets the app data for a person from a given
 * app data response (responseItem.getData() for
 * opensocial.DataRequest.fetchPersonAppDataRequest).
 * 
 * Will return an empty object if no app data was returned for
 * this person.
 * 
 * @param {Object} personData The response data
 * @param {Person|String} person Person or ID of person to get data for.
 *   The strings VIEWER and OWNER cannot be used as parameters.
 *   If this is not specified will return data for the first person
 *   in the response.
 */
SocialNorms.getAppDataFor = function(personData, person) {
  var id = null;
  if (SocialNorms.isString(person)) {
    id = person;
  } else if (person) {
    id = person.getId();
  }
  
  if (id) {
    return SocialNorms.getByKey(personData, id, {});
  } else {
    return SocialNorms.getOnlyValueByKey(personData, {});
  }
};


/**
 * Import opensocial and SocialNorms namespaces into the global namespace.
 */
SocialNorms.importSocialNamespaces = function() {
  // Only imports functions and names > 3 characters
  SocialNorms.importNamespace(opensocial);
  SocialNorms.importNamespace(SocialNorms);
};


/**
 * Get instance data for the current application instance,
 * and copies the key/value pairs on top of an existing object.
 * 
 * Useful for debugging only, as you normally should batch
 * requests for data.
 * 
 * @param {String|Array&ltString&gt} key Key(s) of instance data to get
 * @param {Object} copyTo Object to copy instance data to
 */
SocialNorms.debugGetInstanceData = function(key, copyTo) {
  var keys = SocialNorms.isArray(key) ? key : [key];
  var req = opensocial.newDataRequest();
  req.add(req.newFetchInstanceAppDataRequest(keys), 'get');
  req.send(function(resp) {
    var appData = resp.get('get').getData();
    for (var key in appData) {
      copyTo[key] = appData[key];
    }
  });
};


/**
 * Get application data for a person or people,
 * and copies the key/value pairs on top of an existing object.
 * 
 * If requesting multiple people, keys are personId:key on
 * the resulting object.
 * 
 * Useful for debugging only, as you normally should batch
 * requests for data.
 * 
 * @param {String|Array&ltString&gt} id ID(s) of people to get data for
 * @param {String|Array&ltString&gt} key Key(s) of instance data to get
 * @param {Object} copyTo Object to copy instance data to
 */
SocialNorms.debugGetPersonData = function(id, key, copyTo) {
  var keys = SocialNorms.isArray(key) ? key : [key];
  var ids = SocialNorms.isArray(id) ? id : [id];
  var req = opensocial.newDataRequest();
  req.add(req.newFetchPersonAppDataRequest(id, keys), 'get');
  req.send(function(resp) {
    var personData = resp.get('get').getData();
    var isMultiple = SocialNorms.isArray(id) ||
        id == 'OWNER_FRIENDS' || id == 'VIEWER_FRIENDS';
    for (var i = 0; i < keys.length; i++) {
      if (isMultiple) {
        for (var personId in personData) {
          copyTo[personId + ':' + keys[i]] = 
              SocialNorms.getAppDataFor(personData, personId)[keys[i]];
        }
      } else {
        copyTo[keys[i]] = SocialNorms.getAppDataFor(personData)[keys[i]];
      }
    }
  });
};


/**
 * @private
 */
SocialNorms.isFunction = function(obj) {
  return (typeof obj == 'function');
};


/**
 * @private
 */
SocialNorms.isArray = function(obj) {
  return (obj instanceof Array);
};


/**
 * @private
 */
SocialNorms.isString = function(obj) {
  return (typeof obj == 'string');
};


/**
 * @private
 */
SocialNorms.importNamespace = function(namespace) {
  for (var key in namespace) {
    var value = namespace[key];
    if (key.length > 3 && SocialNorms.isFunction(value)) {
      window[key] = value;
    }
  }
};


/**
 * Get the ID of a person to use for opensocial API calls.
 * Also accepts a string ID parameter as a convenience, will
 * return back the ID.
 * 
 * This supports functions that accept a person or an ID as a parameter.
 * 
 * Returns null if person is null.
 * 
 * @param {Person|String} person Person or ID of person
 * @return {String} ID of the person, may return the keywords
 *   VIEWER and OWNER
 * 
 * @private
 */
SocialNorms.getPersonId = function(person) {
  if (person == null) {
    return person;
  } else if (SocialNorms.isString(person)) {
    return person;
  } else if (person.isViewer()) {
    return 'VIEWER';
  } else if (person.isOwner()) {
    return 'OWNER';
  } else {
    return person.getId();
  }
};


/**
 * Get a value from a JavaScript associative array,
 * returns a default value if array or value is undefined
 * or null.
 * 
 * @param {Object} obj The object to get value from
 * @param {String} key The value key
 * @param {Object} obj Default value to return
 * @private
 */
SocialNorms.getByKey = function(obj, key, defaultValue) {
  if (!obj) {
    return defaultValue;
  }
  
  var value = obj[key];
  return (value != null) ? value : defaultValue;
};


/**
 * Gets the only value from a JavaScript associative array,
 * returns a default value if array or value is undefined
 * or null.
 * 
 * @param {Object} obj The object to get value from
 * @param {Object} obj Default value to return
 * @private
 */
SocialNorms.getOnlyValueByKey = function(obj, defaultValue) {
  if (!obj) {
    return defaultValue;
  }
  
  for (var key in obj) {
    // Won't be called if no keys in object
    return obj[key];
  }
  return defaultValue;
};
