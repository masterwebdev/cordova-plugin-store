module.exports = {
    storefile: function (path, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Store", "storefile", [path]);
    }
};