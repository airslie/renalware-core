
const Rails = window.Rails
const _ = window._
import { Controller } from "@hotwired/stimulus"

// This controller has 3 related functions
// - Keep a users session alive
//   Keep the user's session alive if they are 'active' (there are keypresses,
//   clicks or resize events on the same page) by sending a throttled ajax
//   request to reset the session window which will prevent their session
//   expiring and throwing them out when they are for example writing a long
//   letter (which they would otherwise not finish before their session expires)
// - Auto logging-out a user after a period of inactivity
//   Check after a period of intactivity to see if their session has expired.
//   If it has then refresh the page which will redirect them to the login page.
// - Signalling to other open tabs when the user's session has expired or they
//   have manually logged out - so that all tabs go to the login page at around
//   the same time.
//
// Goals:
// - Performance and code clarity more important than having an accurate session
//   window - if it is extended for a minute or two that is OK.
// - The server should always be the judge of whether the session has timed out
// - Query the server as little as possible - partly for performance and partly
//   to avoid noise in the server logs
// - Keep event handler activity minimal to preserve CPU cycles - ie use
//   throttle or debounce
//
// Possible enhancements:
// - After a period of inactivity, show a dialog asking if user wants to extend
//   the session - this would involve starting a separate timer and displaying
//   the countdown
//
// Scenarios to test:
// - Keypresses, clicks and window resizing - any of these should reset session
//   and thus the user remains logged in as long as one of these events ocurrs
//   within sessionTimeoutSeconds
// - User closes lid on laptop overnight and reopens in the morning - what is
//   expected?
// - Network disconnected - what do we do?
// - user gets withing 10 seconds of session timeout and starts typing - session
//   window shoud be reset
// - user has > 1 tab open and logs out of one - ideally it should log out of
//   other tabs before too long. We do by setting a localStorage value to signal
//   to other tabs
//
// Known issues:
// - user sitting on register page will keep polling checkAlivePath
// - if a user becomes active on a page within throttlePeriodSeconds of
//   sessionTimeoutSeconds then there is no currently opportunity for
//   throttledRegisterUserActivity to reset kick in a trump
//   checkForSessionExpiryTimeout - so the session will log out. We might need
//   an extra step before calling checkForSessionExpiry - a final chance to
//   check if the user was
//   active
// - Not quite sure if putting the data attribute config settings in the body
//   tag is the right thing to do - perhaps should be in a config .js.erb
export default class extends Controller {
  checkForSessionExpiryTimeout = null
  userActivityDetected = false
  checkAlivePath = null
  keepAlivePath = null
  loginPath = null
  throttledRegisterUserActivity = null
  sessionTimeoutSeconds = 0
  defaultSessionTimeoutSeconds = 20 * 60 // 20 mins
  throttlePeriodSeconds = 0
  defaultThrottlePeriodSeconds = 20

  initialize() {
    this.throttlePeriodSeconds = parseInt(this.data.get("register-user-activity-after") || this.defaultThrottlePeriodSeconds)
    this.sessionTimeoutSeconds = parseInt(this.data.get("timeout") || this.defaultSessionTimeoutSeconds)
    this.sessionTimeoutSeconds += 10 // To allow for network roundtrips etc
    this.checkAlivePath = this.data.get("check-alive-path")
    this.loginPath = this.data.get("login-path")
    this.keepAlivePath = this.data.get("keep-alive-path")
    this.logSettings()

    // Throttle the user activity callback because we only need to know about user activity
    // only very occasionally, so that we can periodically tell there server the user was active.
    // Here, even if there are hundreds of events (click, keypress etc) within throttlePeriodSeconds,
    // our function is only called at most once in that period, when throttlePeriodSeconds has
    // passed (since trailing = true). This suits is as we want to avoid making any call to the
    // server unless the user has been on the page for at least throttlePeriodSeconds.
    // See https://lodash.com/docs/#trottle
    this.throttledRegisterUserActivity = _.throttle(
      this.registerUserActivity.bind(this),
      this.throttlePeriodSeconds * 1000,
      { "leading": false, "trailing": true }
    )
  }

  connect() {
    if (this.onLoginPage) {
      this.log("connect: onLoginPage - skipping session time")
    } else {
      this.addHandlersToMonitorUserActivity()
      this.resetCheckForSessionExpiryTimeout(this.sessionTimeoutSeconds)
    }
  }

  disconnect() {
    if (!this.onLoginPage) {
      this.removeUserActivityHandlers()
      clearTimeout(this.checkForSessionExpiryTimeout)
    }
  }

  sendLogoutMessageToAnyOpenTabs() {
    window.localStorage.setItem("logout-event", "logout" + Math.random())
  }

  // Debounced event handler for key/click/resize
  // If we come in there then the user has interacted with the page
  // within throttlePeriodSeconds
  registerUserActivity() {
    this.sendRequestToKeepSessionAlive()
    this.resetCheckForSessionExpiryTimeout(this.sessionTimeoutSeconds)
  }

  // Timeout handler for checking if the sesison has expired
  resetCheckForSessionExpiryTimeout(intervalSeconds) {
    this.log(`resetting session expiry timeout ${intervalSeconds}`)
    clearTimeout(this.checkForSessionExpiryTimeout)
    this.checkForSessionExpiryTimeout = setTimeout(
      this.checkForSessionExpiry.bind(this),
      intervalSeconds * 1000
    )
  }

  // Here we really expect the session to have expired. In case it hasn't
  // we reset the timeout to check again. We could reset the timeout to be
  // sessionTimeoutSeconds, but if when we checked for expiry we had only just
  // missed it, we will end up staying on this page (assuming the user is
  // inactive) for nearly twice as long as we need to. So we set the timeout
  // to be throttlePeriodSeconds * 2, which gives time for the
  // throttledRegisterUserActivity handler to reset the session again if it
  // fires.
  checkForSessionExpiry() {
    this.sendRequestToTestForSessionExpiry()
    this.resetCheckForSessionExpiryTimeout(this.throttlePeriodSeconds * 2)
  }

  sendRequestToKeepSessionAlive() {
    this.ajaxGet(this.keepAlivePath)
  }

  sendRequestToTestForSessionExpiry() {
    this.log("checking for session expiry")
    this.ajaxGet(this.checkAlivePath)
  }

  ajaxGet(path) {
    Rails.ajax({
      type: "GET",
      url: path,
      dataType: "text",
      error: this.reloadPageIfAjaxRequestWasUnauthorised.bind(this)
    })
  }

  reloadPageIfAjaxRequestWasUnauthorised(responseText, status, xhr) {
    if (xhr.status == 401) {
      window.location.reload()
      this.sendLogoutMessageToAnyOpenTabs()
    }
  }

  addHandlersToMonitorUserActivity() {
    document.addEventListener("click", this.throttledRegisterUserActivity.bind(this))
    document.addEventListener("keydown", this.throttledRegisterUserActivity.bind(this))
    window.addEventListener("resize", this.throttledRegisterUserActivity.bind(this))
    window.addEventListener("storage", this.storageChange.bind(this))
  }

  removeUserActivityHandlers() {
    document.removeEventListener("click", this.throttledRegisterUserActivity.bind(this))
    document.removeEventListener("keydown", this.throttledRegisterUserActivity.bind(this))
    window.removeEventListener("resize", this.throttledRegisterUserActivity.bind(this))
    window.removeEventListener("storage", this.storageChange.bind(this))
  }

  logSettings() {
    if (this.debug) {
      this.log(`keepAlivePath ${this.keepAlivePath}`)
      this.log(`checkAlivePath ${this.checkAlivePath}`)
      this.log(`loginPath ${this.loginPath}`)
      this.log(`sessionTimeoutSeconds ${this.sessionTimeoutSeconds}`)
      this.log(`throttlePeriodSeconds ${this.throttlePeriodSeconds}`)
    }
  }

  log(msg) {
    if (this.debug) {
      console.log(msg)
    }
  }

  // An event handler to watch for changes in the value of the local storage item called
  // 'logged_in'. We use localStorage as a cross-tab communication protocol: when the user has
  // logged out of one tab, this mechanism is used to signal to any other logged-in tabs that they
  // should log themselves out.
  // This applies in 2 circumstances:
  // - the user has clicked the "Log Out" link in the navbar - the sendLogoutMessageToAnyOpenTabs()
  //   action defined above is called
  // - our tab has timed out due to inactivity; other open tabs may not timeout for another few
  //   minutes (depending on the polling frequency etc) so we give them a nudge.
  storageChange(event) {
    if(event.key == "logout-event") {
      setTimeout(this.sendRequestToTestForSessionExpiry.bind(this), 2000)
    }
  }

  get onLoginPage() {
    return window.location.pathname == this.loginPath
  }

  // If you add data-session-debug=1 then logging will be enabled
  // This is evaluated each time we can add debugging into a running page
  get debug() {
    return this.data.get("debug") === "true"
  }
}
