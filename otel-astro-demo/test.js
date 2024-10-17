email = "The one-time passcode (OTP) for your account is 34363325. It is valid for 15 minutes. Enter it now to continue logging in. Please do not reply."
let match = email.match(/\d{8}/);
let otpcode
try {
  if (match) {
    otpcode = match[0]
  } else {
    match = email.match(/\d{7}/);
    otpcode = match[0]
  }
}
catch (e) {
}
EMAIL_DATA_PARSED = otpcode
console.log("OTP code is",EMAIL_DATA_PARSED)

