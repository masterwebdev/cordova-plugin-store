cordova.define("com.autovitalsinc.store.store", function(require, exports, module) {
module.exports = {
	initdirs: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Store", "initdirs", []);
    },
    savefile: function (params, successCallback, errorCallback) {
    	if(typeof params.append == 'undefined'){
    		params.append='false';
    	}
    	//var dd=;
        cordova.exec(successCallback, errorCallback, "Store", "savefile", [params.filename,JSON.stringify(params.data),params.append]);
        //cordova.exec(successCallback, errorCallback, "Store", "savefile", [params.filename,params.data,params.append]);
        //delete dd;
    },
    truncate: function (params, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Store", "truncate", [params.filename,params.length]);
    },
    readfile: function (path, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Store", "readfile", [path]);
    },
    storefile: function (path, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Store", "storefile", [path]);
    }
};
});
