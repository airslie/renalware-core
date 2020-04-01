
const Rails = window.Rails
import { Controller } from "stimulus"

// Test for session timeout after a period of idleness.
// Concept:
// - Click/keydown events will reset the session timeout window.
//   For example if the server session timeout is 20 minutes and is reset
//   whenever there is a navigation, then lets assume the user has not
//   navigated or used the UI for say 3 minutes (the userActivityTimeout
//   interval), so the userActivityTimeout handler is called. Here
//   we make an ajax request to the server to reset the start of the session
//   so the user now has 20 minutes to navigate or interact with the page
//   or else we will redirect them to the login page. To allow this happen we
//   must keep track of the number of times our userActivityTimeout has fired
//   with no intervening user activity. Each time one of these congiguous idle
//   events occur we send an ajax request which does not reset the session
//   window but will cause the user to be logged off when the session has
//   eventually expired.
// Goals:
// - Preformance and code clarity more important than having an accurate session
//   window - if it is extended for a minute or two that is OK.
// - The server should always be the judge of whether the session has timed out
// - Query the server as little as possible
// - Keep event handler activity minimal to preserve CPU cycles
// - Tidyup all event listeners
// Nice to have:
// - After a period of inactivity, show a dialog asking if user wants to extend
//   the session - this would involve starting a separate timer and displaying
//   the countdown
// Scenarios to test:
// - Keypresses - Typing past the server session timeout does not cause a redirect
// - Mouse move - not sure perhaps we do not need to monitor these. As user is
//   likely to click on something (or type) within the session timeout period
//   so monitoring those 2 events may be enough, perhaps with scroll.
// - User closes lid on laptop overnight
// - Network disconnected - what do we do?
// - user gets withing 30 seconds of session timeout and starts typing - session
//   window shoud be reset
// - user types constantly for entire session timeout period - should
//   continually reset session window.
// - user has > 1 tab open and logs out of one - ideally it should log out of
//   other tabs before too long. We do by setting a localStorage value to signal to other tabs
// TODO:
// - user sitting on rtegister page will keep polling checkAlivePath
// - read urls etc in initialize() to be safe - rather than lazy getter or connect
// - move HTML element definition (ie where data controller is declared) into helper or component
export default class extends Controller {
  sessionTimeoutSeconds = 0
  secondsAtPageLoad = 0
  secondsAtLastActivity = 0
  pollingIntervalSeconds = 0
  checkUserActivityTimeout = null
  userActivityDetected = false
  static DEFAULT_SESSION_TIMEOUT = 20 * 60 // 20 mins
  static DEFAULT_POLLING_INTERVAL = 3 * 60 // 3 mins

  connect() {
    this.secondsAtPageLoad = this.secondsAtLastActivity = this.secondsSinceEpoch
    if (!this.onLoginPage) {
      this.sessionTimeoutSeconds = parseInt(this.data.get("timeout") || this.DEFAULT_SESSION_TIMEOUT)
      this.pollingIntervalSeconds = parseInt(this.data.get("polling-interval") || this.DEFAULT_POLLING_INTERVAL)
      this.logSettings()
      this.addHandlersToMonitorUserActivity()
      this.resetCheckUserActivityTimeout()
    } else {
      this.log("connect: onLoginPage - skipping session time")
    }
  }

  disconnect() {
    this.log(`disconnect onLoginPage: ${this.onLoginPage}`)
    if (!this.onLoginPage) {
      this.removeUserActivityHandlers()
    }
  }

  sendLogoutMessageToAnyOpenTabs() {
    window.localStorage.setItem("logout-event", "logout" + Math.random())
  }

  // Event handler for key/click/resize
  registerUserActivity() {
    this.secondsAtLastActivity = this.secondsSinceEpoch
    this.userActivityDetected = true
  }

  // Timer handler
  resetCheckUserActivityTimeout() {
    clearTimeout(this.checkUserActivityTimeout)
    this.checkUserActivityTimeout = setTimeout(
      this.checkUserActivity.bind(this),
      this.pollingIntervalSeconds * 1000
    )
  }

  checkUserActivity() {
    this.logAnyUserActivity()

    if (this.userActivityDetected == true) {
      this.sendRequestToKeepSessionAlive()
    } else {
      if (this.timeToAskServerToLogUserOut()) {
        this.log("sendRequestToTestForSessionExpiry")
        this.sendRequestToTestForSessionExpiry()
      }
    }
    this.userActivityDetected = false
    this.resetCheckUserActivityTimeout(this.pollingIntervalSeconds)
  }

  sendRequestToKeepSessionAlive() {
    this.ajaxGet(this.keepAlivePath)
  }

  sendRequestToTestForSessionExpiry() {
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

  timeToAskServerToLogUserOut() {
    return (this.secondsSinceLastActivity >= this.secondsAfterWhichWeStartAskingServerToLogUserOut)
  }

  addHandlersToMonitorUserActivity() {
    document.addEventListener("click", this.registerUserActivity.bind(this))
    document.addEventListener("keydown", this.registerUserActivity.bind(this))
    window.addEventListener("storage", this.storageChange.bind(this))
  }

  removeUserActivityHandlers() {
    document.removeEventListener("click", this.registerUserActivity.bind(this))
    document.removeEventListener("keydown", this.registerUserActivity.bind(this))
    window.removeEventListener("storage", this.storageChange.bind(this))
  }

  logSettings() {
    if (this.debug) {
      // this.log(`secondsAtPageLoad ${this.secondsAtPageLoad}`)
      this.log(`keepAlivePath ${this.keepAlivePath}`)
      this.log(`checkAlivePath ${this.checkAlivePath}`)
      this.log(`loginPath${this.loginPath}`)
      this.log(`sessionTimeoutSeconds ${this.sessionTimeoutSeconds}`)
      this.log(`pollingIntervalSeconds ${this.pollingIntervalSeconds}`)
    }
  }

  logAnyUserActivity() {
    this.log("************************")
    this.log(`Activity detected: ${this.userActivityDetected}`)
    this.log(`secondsSinceLastActivity ${this.secondsSinceLastActivity}`)
    this.log(`secondsAfterWhichWeStartAskingServerToLogUserOut ${this.secondsAfterWhichWeStartAskingServerToLogUserOut}`)
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

  get secondsSinceEpoch() {
    return Math.floor(Date.now() / 1000)
  }

  get onLoginPage() {
    return window.location.pathname == this.loginPath
  }

  get checkAlivePath() {
    return this.data.get("check-alive-path")
  }

  get loginPath() {
    return this.data.get("login-path")
  }

  get keepAlivePath() {
    return this.data.get("keep-alive-path")
  }

  // If you add data-session-debug=1 then logging will be enabled
  get debug() {
    return this.data.get("debug")
  }

  get secondsSinceLastActivity() {
    return this.secondsSinceEpoch - this.secondsAtLastActivity
  }

  // This is the Devise session timeout less the duration of a polling interval.
  // What this means is that when this is only one polling interval before the
  // expected end of the session, at this point we should start sending a message
  // to the server (at each of the remaning polling intervals) to give the server
  // a chance to log us out.
  get secondsAfterWhichWeStartAskingServerToLogUserOut() {
    return this.sessionTimeoutSeconds - this.pollingIntervalSeconds
  }
}
