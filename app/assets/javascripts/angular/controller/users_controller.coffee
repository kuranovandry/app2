myApp = angular.module('myapplication', [
  'ngRoute'
  'ngResource'
])
myApp.factory 'Users', [
  '$resource'
  ($resource) ->
    $resource '/users.json', {},
      query:
        method: 'GET'
        isArray: true
      create: method: 'POST'
]
myApp.factory 'User', [
  '$resource'
  ($resource) ->
    $resource '/users/:id.json', {},
      show: method: 'GET'
      update:
        method: 'PUT'
        params: id: '@id'
      delete:
        method: 'DELETE'
        params: id: '@id'
]
myApp.controller 'UserListController', [
  '$scope'
  '$http'
  '$resource'
  'Users'
  'User'
  '$location'
  ($scope, $http, $resource, Users, User, $location) ->
    $scope.users = Users.query()

    $scope.deleteUser = (userId) ->
      if confirm('Are you sure you want to delete this user?')
        User.delete { id: userId }, ->
          $scope.users = Users.query()
          $location.path '/'
          return
      return

    return
]
myApp.controller 'UserUpdateController', [
  '$scope'
  '$resource'
  'User'
  '$location'
  '$routeParams'
  ($scope, $resource, User, $location, $routeParams) ->
    $scope.user = User.get(id: $routeParams.id)

    $scope.update = ->
      if $scope.userForm.$valid
        User.update { id: $scope.user.id }, { user: $scope.user }, (->
          $location.path '/'
          return
        ), (error) ->
          console.log error
          return
      return

    return
]
myApp.controller 'UserAddCtr', [
  '$scope'
  '$resource'
  'Users'
  '$location'
  ($scope, $resource, Users, $location) ->

    $scope.save = ->
      if $scope.userForm.$valid
        Users.create { user: $scope.user }, (->
          $location.path '/'
          return
        ), (error) ->
          console.log error
          return
      return

    return
]
myApp.config [
  '$routeProvider'
  '$locationProvider'
  ($routeProvider, $locationProvider) ->
    $routeProvider.when '/users',
      templateUrl: '/templates/users/index.html'
      controller: 'UserListController'
    $routeProvider.when '/users/new',
      templateUrl: '/templates/users/new.html'
      controller: 'UserAddController'
    $routeProvider.when '/users/:id/edit',
      templateUrl: '/templates/users/edit.html'
      controller: 'UserUpdateController'
    $routeProvider.otherwise redirectTo: '/users'
    return
]