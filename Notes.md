Site Webmanafest :

//The display property in the Web App Manifest determines how your web app is shown when launched. Here are the possible values:

//fullscreen: The app will be displayed in full-screen mode, without any browser UI elements (like the address bar or navigation controls). This makes the app feel like a native mobile app.

//standalone: The app is displayed in its own window, without browser chrome (i.e., no address bar or tabs), but it still has a status bar at the top. This gives a more native app feel, but users can still see that it's a web app (in contrast to fullscreen).

//minimal-ui: Similar to standalone, but with a minimal set of browser UI elements, such as back and forward buttons, and a URL bar. It’s useful for apps that want to be more web-like but still need some navigation.

//browser: The app behaves like a standard webpage inside the browser with the full set of browser UI elements, including the address bar and tabs.



Areas for Improvement and Explanation:

Background Video Handling: The background video implementation is good, but consider adding a fallback image for browsers that don't support video or for users with disabled video.

NFC Data Parsing: The code handles 'text' and 'url' record types.  It's crucial to define a specific data format for your NFC tags.  Don't rely on just checking for "Boost 350".  Use a structured format (like JSON) to store shoe information. This will make your verification process much more robust.

Verification Logic: The current verification logic is extremely basic.  It just checks if "Boost 350" is present.  A real-world system would need to:

Cryptographic Verification: Use a digital signature or hash to ensure the NFC data hasn't been tampered with. This is essential for security.
Database Lookup: Compare the NFC data (e.g., a unique shoe ID) against a database of legitimate shoes.
More Detailed Information: Display more information about the shoe (e.g., size, color, authenticity certificate) after verification.
User Feedback:  Provide more informative feedback to the user during the scanning and verification process.  For example:

"Connecting to NFC reader..."
"Processing data..."
"Verification successful! Shoe details:" (followed by the details)
"Verification failed: Invalid NFC tag."
"Verification failed: Shoe not found in database."
UI/UX Enhancements:

Loading Indicator: Show a loading spinner or progress bar while the NFC data is being processed.
Button State: Disable the "Verify" button while a scan is in progress to prevent multiple clicks.
Clearer Instructions: Provide more explicit instructions to the user (e.g., "Hold your phone near the shoe's tag").
Styling: Improve the styling of the output display to make the information easier to read. Consider using a table or list to present shoe details.
Security Considerations:

HTTPS: The website must be served over HTTPS to protect the NFC data and prevent man-in-the-middle attacks.
Data Validation: Sanitize and validate all data received from the NFC tag to prevent injection attacks.

TODO: 
add confetti

