README for GrubClub iOS application

GrubClub aims to ensure that no one eats alone anymore by providing a video streaming and friend matching service.

Alpha Stage

Expected Use cases to be running 
	1. Main Screen -> Login -> Friends list
		- Returns message to user if invalid password and/or username 
	2. Main Screen -> Create an account -> Submit -> Receive verification email -> Click verify link -> Main Screen -> Login  -> Friends list
		- Error handling for improper user input
			a) Email 
			b) Username
			c) Password 
			d) Name 
		- Notifies user if email and/or username is taken 
	3. Forgot password? -> Retrieve Account Password -> Reset password -> Main Screen -> Login  -> Friends list
		- Error handling for improper user email 
		- Notifies user if email does not exist 


Beta Roadmap 
Our beta stage should include at least a basic implementation of video streaming/sharing between users on the app who have an ongoing session. We imagine this to be fairly 
difficult and many issues relating to unavailability to large bandwidth, fluctuations in download/upload speeds, all in addition to maintaining an at least moderate video 
quality stream. Again, testing this feature ourselves, finding run-time issues, and identifying small issues that can be solvable without spending too much time on them.
