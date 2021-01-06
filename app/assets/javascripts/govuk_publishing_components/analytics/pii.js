/* global $ */

;(function (global) {
  'use strict'

  var GOVUK = global.GOVUK || {}
  var EMAIL_PATTERN = /[^\s=/?&]+(?:@|%40)[^\s=/?&]+/g
  var POSTCODE_PATTERN = /[A-PR-UWYZ][A-HJ-Z]?[0-9][0-9A-HJKMNPR-Y]?(?:[\s+]|%20)*[0-9](?!refund)[ABD-HJLNPQ-Z]{2,3}/gi
  var DATE_PATTERN = /\d{4}(-?)\d{2}(-?)\d{2}/g
  var ESCAPE_REGEX_PATTERN = /[|\\{}()[\]^$+*?.]/g

  // specific URL parameters to be redacted from accounts URLs
  var RESET_PASSWORD_TOKEN_PATTERN = /reset_password_token=[a-zA-Z0-9-]+/g
  var UNLOCK_TOKEN_PATTERN = /unlock_token=[a-zA-Z0-9-]+/g
  var STATE_PATTERN = /state=.[^&]+/g

  function shouldStripDates () {
    return ($('meta[name="govuk:static-analytics:strip-dates"]').length > 0)
  }

  function shouldStripPostcodes () {
    return ($('meta[name="govuk:static-analytics:strip-postcodes"]').length > 0)
  }

  function queryStringParametersToStrip () {
    var value = $('meta[name="govuk:static-analytics:strip-query-string-parameters"]').attr('content')
    var parameters = []

    if (value) {
      var split = value.split(',')
      for (var i = 0; i < split.length; i++) {
        parameters.push(split[i].trim())
      }
    }

    return parameters
  }

  var pii = function () {
    this.stripDatePII = shouldStripDates()
    this.stripPostcodePII = shouldStripPostcodes()
    this.queryStringParametersToStrip = queryStringParametersToStrip()
  }

  pii.prototype.stripPII = function (value) {
    if (typeof value === 'string') {
      return this.stripPIIFromString(value)
    } else if (Object.prototype.toString.call(value) === '[object Array]' || Object.prototype.toString.call(value) === '[object Arguments]') {
      return this.stripPIIFromArray(value)
    } else if (typeof value === 'object') {
      return this.stripPIIFromObject(value)
    } else {
      return value
    }
  }

  pii.prototype.stripPIIFromString = function (string) {
    var stripped = string.replace(EMAIL_PATTERN, '[email]')
    stripped = stripped.replace(RESET_PASSWORD_TOKEN_PATTERN, 'reset_password_token=[reset_password_token]')
    stripped = stripped.replace(UNLOCK_TOKEN_PATTERN, 'unlock_token=[unlock_token]')
    stripped = stripped.replace(STATE_PATTERN, 'state=[state]')
    stripped = this.stripQueryStringParameters(stripped)

    if (this.stripDatePII === true) {
      stripped = stripped.replace(DATE_PATTERN, '[date]')
    }
    if (this.stripPostcodePII === true) {
      stripped = stripped.replace(POSTCODE_PATTERN, '[postcode]')
    }
    return stripped
  }

  pii.prototype.stripPIIFromObject = function (object) {
    if (object) {
      if (object instanceof GOVUK.Analytics.PIISafe) {
        return object.value
      } else {
        for (var property in object) {
          var value = object[property]

          object[property] = this.stripPII(value)
        }
        return object
      }
    }
  }

  pii.prototype.stripPIIFromArray = function (array) {
    for (var i = 0, l = array.length; i < l; i++) {
      var elem = array[i]

      array[i] = this.stripPII(elem)
    }
    return array
  }

  pii.prototype.stripQueryStringParameters = function (string) {
    for (var i = 0; i < this.queryStringParametersToStrip.length; i++) {
      var parameter = this.queryStringParametersToStrip[i]
      var escaped = parameter.replace(ESCAPE_REGEX_PATTERN, '\\$&')
      var regexp = new RegExp('((?:\\?|&)' + escaped + '=)(?:[^&#\\s]*)', 'g')
      string = string.replace(regexp, '$1[' + parameter + ']')
    }

    return string
  }

  GOVUK.Pii = pii

  global.GOVUK = GOVUK
})(window)
