var app = angular.module('myApp', []);
app.controller('myCtrl', function($scope, $http) {
    var BASEURL_GCP = "http://35.238.22.185:9010/process?";
    var BASEURL_LOCAL = "http://localhost:9010/process?";
    $scope.loading = false;
    $scope.SendRequest = function(form) {
        alert("Here");
        $scope.loading = true;
        console.log("Starting Processing...")
        var getURL = BASEURL_LOCAL + "sd=" + form.sd + "&sdpath=" + form.sdpath;
        getURL += "&crpath=" + form.crpath + "&crr=" + form.crr + "&bqs=" + form.bqs + "&config=" + form.config + "&cr=" + form.cr;
        getURL = encodeURI(getURL);
        console.log("getURL=" + getURL);
        $http({
            method: "GET",
            url: getURL
        }).then(
            function successCallback(response) {
                // this callback will be called asynchronously
                // when the response is available
                $scope.loading = false;

                console.log("##### Response=" + response);
            },
            function errorCallback(error) {
                console.log("##### Error=" + error);
            }
        );
    };
});