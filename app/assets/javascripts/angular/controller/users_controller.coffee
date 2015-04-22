myApp = angular.module('myapplication', [
  'ngRoute'
  'ngResource'
])
myApp.factory('routingErrorInterceptor', [
  '$rootScope', '$q', '$location'
  ($rootScope, $q, $location) ->
    return {
      responseError: (response) ->
        if response.status is 404
          deferred = $q.defer()
          $location.path('/404')
          return deferred.promise
        $q.reject response
      responseSuccess: (response) ->
        response
    }
]).config [
  '$httpProvider'
  ($httpProvider) ->
    $httpProvider.interceptors.push 'routingErrorInterceptor'
]
myApp.factory('serverErrorInterceptor', [
  '$rootScope', '$q', '$location'
  ($rootScope, $q, $location) ->
    return {
      responseError: (response) ->
        if response.status is 500
          deferred = $q.defer()
          $location.path('/500')
          return deferred.promise
        $q.reject response
      responseSuccess: (response) ->
        response
    }
]).config [
  '$httpProvider'
  ($httpProvider) ->
    $httpProvider.interceptors.push 'serverErrorInterceptor'
]
myApp.factory 'Users', [
  '$resource'
  ($resource) ->
    $resource 'api/v1/users.json', {},
      query:
        method: 'GET'
        isArray: true
      create: method: 'POST'
]
myApp.factory 'User', [
  '$resource'
  ($resource) ->
    $resource 'api/v1/users/:id.json', {},
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
myApp.controller 'UserAddController', [
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
