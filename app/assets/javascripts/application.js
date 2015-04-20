// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require angular
//= require angular-route
//= require angular-resource
//= require angular-ui-bootstrap
//= require angularjs/rails/resource
//= require_tree .

var myApp = angular.module('myapplication', ['ngRoute', 'ngResource']); 

myApp.factory('Users', ['$resource',function($resource){
  return $resource('/users.json', {},{
    query: { method: 'GET', isArray: true },
    create: { method: 'POST' }
  })
}]);

myApp.factory('User', ['$resource', function($resource){
  return $resource('/users/:id.json', {}, {
    show: { method: 'GET' },
    update: { method: 'PUT', params: {id: '@id'} },
    delete: { method: 'DELETE', params: {id: '@id'} }
  });
}]);

myApp.controller("UserListController", ['$scope', '$http', '$resource', 'Users', 'User', '$location', function($scope, $http, $resource, Users, User, $location) {

  $scope.users = Users.query();

  $scope.deleteUser = function (userId) {
    if (confirm("Are you sure you want to delete this user?")){
      User.delete({ id: userId }, function(){
        $scope.users = Users.query();
        $location.path('/');
      });
    }
  };
}]);

myApp.controller("UserUpdateController", ['$scope', '$resource', 'User', '$location', '$routeParams', function($scope, $resource, User, $location, $routeParams) {
  $scope.user = User.get({id: $routeParams.id})
  $scope.update = function(){
    if ($scope.userForm.$valid){
      User.update({id: $scope.user.id},{user: $scope.user},function(){
        $location.path('/');
      }, function(error) {
        console.log(error)
      });
    }
  };


}]);

myApp.controller("UserAddCtr", ['$scope', '$resource', 'Users', '$location', function($scope, $resource, Users, $location) {
  $scope.save = function () {
    if ($scope.userForm.$valid){
      Users.create({user: $scope.user}, function(){
        $location.path('/');
      }, function(error){
        console.log(error)
      });
    }
  }
}]);


myApp.config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    $routeProvider.when('/users',{
      templateUrl: '/templates/users/index.html',
      controller: 'UserListController'
    });
    $routeProvider.when('/users/new', {
      templateUrl: '/templates/users/new.html',
      controller: 'UserAddController'
    });
    $routeProvider.when('/users/:id/edit', {
      templateUrl: '/templates/users/edit.html',
      controller: "UserUpdateController"
    });
    $routeProvider.otherwise({
      redirectTo: '/users'
    });
  }
]);