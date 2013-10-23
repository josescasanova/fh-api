'use strict';
var API_HOST = "http://localhost:8080";
var SITE_ROOT = "http://localhost:5000";

angular.module('burritoApp', ['ngRoute', 'directives'])
  .config(['$routeProvider', function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  }]);

