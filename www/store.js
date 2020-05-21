module.exports = {
	initdirs: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Store", "initdirs", []);
    },
    savefile: function (params, successCallback, errorCallback) {
    	if(typeof params.append == 'undefined'){
    		params.append='false';
    	}
        cordova.exec(successCallback, errorCallback, "Store", "savefile", [params.filename,params.data,params.append]);
    },
    savefile64: function (params, successCallback, errorCallback) {
        if(typeof params.append == 'undefined'){
            params.append='false';
        }
        cordova.exec(successCallback, errorCallback, "Store", "savefile64", [params.filename,params.data,params.append]);
    },
    truncate: function (params, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Store", "truncate", [params.filename,params.length]);
    },
    readfile: function (path, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Store", "readfile", [path]);
    },
    readfileplain: function (path, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Store", "readfileplain", [path]);
    },
    storefile: function (path, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Store", "storefile", [path]);
    },
    loadfile: function (params, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Store", "loadfile", params);
    }
};