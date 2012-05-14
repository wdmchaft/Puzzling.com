/**
 * Created with JetBrains WebStorm.
 * User: jimzheng
 * Date: 5/12/12
 * Time: 3:31 AM
 * Common utility functions
 */

// Custom typeof and instanceof
// Usage:
// utils.is('String', myObj)
// returns true if obj is of type type

exports.is = function (type, obj) {
    var _class = Object.prototype.toString.call(obj).slice(8, -1);
    return obj !== undefined && obj !== null && _class === type;
};

// strips any extra chars
// from input string, leaving
// only alphanumeric chars

exports.stripNonAlphaNum = function(input) {
    if(!this.is('String', input)) return '';
    return (input || '').replace(/[^\w+\d]/g, '');
};