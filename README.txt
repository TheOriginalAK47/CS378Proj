README for GrubClub iOS application

GrubClub aims to ensure that no one eats alone anymore by providing a video streaming and friend matching service.

Features so far:

- Account sign-up
	- Validates all fields when signing up to make sure they are textually valid
	- Ensures that no other users have the same username or email within our database
	- If the above conditions are true, sends a confirmation email to user which they need to act upon to sign-in
	- Password fields are secure so as to ensure some sense of security

- Account Login
	- Performs a query on our DB to see if username/password combo exists. If so, allow login, else tell user the account info provided is incorrect.

- Chat List
	- Shows a list of other users the user is "friends" with and communicate with in the application

- Add Friends Screen
	- Have screens for requesting friends and sending requests to other users but no back-end servicing yet

- Video Stream Screen
	- Screen exists but is not implemented/functional yet