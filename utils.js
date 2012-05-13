/**
 * Created with JetBrains WebStorm.
 * User: jimzheng
 * Date: 5/12/12
 * Time: 3:31 AM
 * Common utility functions
 */

// strips any extra chars
// from input string, leaving
// only alphanumeric chars

exports.stripNonAlphaNum = function(input) {
    return input.replace(/[^\w+\d]/g, '');
};