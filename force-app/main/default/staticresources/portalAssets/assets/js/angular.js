var app = angular.module('ngApp', []);

app.controller('loginCtrl', function ($scope) {

    $scope.email = undefined;
    $scope.password = undefined;

    $scope.goTo = function (loginForm) {
        console.log(loginForm.$valid);
        if (loginForm.$valid) {
            // remoting action
            console.log($scope.email);
            console.log($scope.password);
            Visualforce.remoting.Manager.invokeAction(
                '{!$RemoteAction.profileController.login}',
                $scope.email,
                $scope.password,
                function (result, event) {
                    if (result) {
                        if (result.length > 0) {
                            console.log('not Found')
                        } else {
                            console.log('not FOund')
                        }
                    }
                },
                { escape: true }
            );
        } else {
            $scope.email = undefined;
            $scope.password = undefined;
        }
        // window.location.replace('/apex/Profile');
        event.preventDefault();
        return false;
    }
});


app.controller('profileCtrl', function ($scope) {
    $scope.userDetail = '{!contactList}';
    console.log("$scope.userDetail", $scope.userDetail);
});