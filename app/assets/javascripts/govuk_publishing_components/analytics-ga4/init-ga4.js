window.GOVUK = window.GOVUK || {}
window.GOVUK.analyticsGa4 = window.GOVUK.analyticsGa4 || {}

var initFunction = function () {
  var consentCookie = window.GOVUK.getConsentCookie()

  if (consentCookie && consentCookie.usage) {
    window.GOVUK.analyticsGa4.vars.internalDomains = []
    window.GOVUK.analyticsGa4.vars.internalDomains.push(window.GOVUK.analyticsGa4.core.trackFunctions.getHostname())
    window.GOVUK.analyticsGa4.core.trackFunctions.appendDomainsWithoutWWW(window.GOVUK.analyticsGa4.vars.internalDomains)
    var attachmentLinkData = [
      { key: 'data-module', value: 'ga4-link-tracker' },
      { key: 'data-ga4-track-links-only', value: '' },
      { key: 'data-ga4-link', value: JSON.stringify({ event_name: 'navigation', type: 'html attachment' }) }]
    window.GOVUK.analyticsGa4.core.trackFunctions.addAttributesToElements('[data-ga4-attachment-link]', attachmentLinkData)
    window.GOVUK.analyticsGa4.core.load()

    var analyticsModules = window.GOVUK.analyticsGa4.analyticsModules
    for (var property in analyticsModules) {
      var module = analyticsModules[property]
      if (typeof module.init === 'function') {
        try {
          module.init()
        } catch (e) {
          // if there's a problem with the module, catch the error to allow other modules to start
          console.warn('Error starting analytics module ' + property + ': ' + e.message, window.location)
        }
      }
    }
  } else {
    window.addEventListener('cookie-consent', window.GOVUK.analyticsGa4.init)
  }
}

window.GOVUK.analyticsGa4.init = initFunction
