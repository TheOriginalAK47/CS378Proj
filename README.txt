Final

Expected Use cases to be running 

a) Main Screen -> Login -> Friends list
Returns message to user if invalid password and/or username 

b) Main Screen -> Create an account -> Submit -> Receive 
verification email -> Click verify link -> Main Screen -> Login  -
> Friends list
Error handling for improper user input:
	Email 
	Username
	Password 
	Name 
Notifies user if email and/or username is taken 

c) Forgot password? -> Retrieve Account Password -> Reset password -> Main Screen -> Login  -> Friends list
	Error handling for improper user email 
	Notifies user if email does not exist 
	
d) Main Screen -> Login -> Friends list -> Add Users -> Friend 

e)Requests Screen -> Search -> Search for user alert -> input 
username -> results of search -> Add user OR cancel -> Friend 
Requests 

f) Main Screen -> Login -> Friends list -> Select Friend Request -> Accept or Reject option -> See new friend in Friends List upon 
acceptance

g) Main Screen -> Login -> Friends list -> Select a user -> Call 
user assuming they have opposite user pulled up on their end to ->
 Stream call until completion (This needs to be done with 
 physical device as it is not configured to work on emulator. 
 Will of course be changed so that call can be received anywhere 
 in final demo)

Final version involved largely debugging the application through some testing scenarios we ran, UI tweaks to make the front-end a little more pleasant, sessions for users and indication of how’s online versus offline in the friends list. We didn’t have enough time to have people interact with it directly but that’s definitely something we can look at in the near future.

Items completed:
	- Added user session tokens/graphics next to users who are online
	- Ran test scenarios by hand to ensure app was satisfying basic use cases/requirements
	- Added active activity element in initial splash screen
	- Improved the Video Chat View to have a larger main video UI element and brought the hang-up button to the front so the user could see it

Future improvements/subsequent stages (Not for final turnin)
	Add user profile element where users fill out preferences 
	relating to cuisine and restaurants
	
	Have restaraunt matching service between two users, as a 
	complement to the video feature in case users want to meet in-
	person instead

	Add location services and include back-end with data 
	functionality like Google Places or Yelp! API

	Create an algorithm to suggest places based on users 
	preferences and other relevant meta-data
