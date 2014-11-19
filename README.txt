Beta 

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

Final product Roadmap 
 At this point we would hope to have the video streaming tweaked 
 and optimized as best as we can for the end users. We would of 
 course have friends/early adopters try it out and see how they 
 like it, how it can improve, what needs more work and what they 
 don’t think is needed. If ready, submit to app store. If still 
 more time we would look into adding some of the adopted 
 incremental updates mentioned before. If we undergo implementing 
 the latter features which are centered around physical meet-ups, 
 investigate business model of soliticing to local restaurants to 
 see if they would have interest in paying to list their 
 restaurant higher in certain situations.

To-do’s include: 
	Allowing for calls to be received on any view-controller as 
	long as a user is logged in. Isn’t included because of 
	difficulty of problem in that we need to implement a 
	singleton design pattern and will likely need to do extensive 
	testing to ensure feature works properly

	Enhancing dimensionality of video feed to be more proportional
	. Should be simple but needs to be looked at closely to see 
	what users like.

	Play with optimization of streaming quality. Not sure how 
	difficult as we haven’t tried app with weaker WIFI/data 
	connections

	Add polish relating to user-experience which runs the gamut 
	from improved design and view layouts, seeing what users 
	like/dislike, and other improvements related to usability. 
	Lots of potential and work here and will likely be be done by 
	consulting students/friends with extensive design/UX 
	experience so that it will be of a higher quality.

	Add back in a local sound file so that there is a ringing 
	sound when a user is receiving a call request. Simple fix but 
	requires understanding of some bundle API functions

Future improvements/subsequent stages (Not for final presentation)
	Add user profile element where users fill out preferences 
	relating to cuisine and restaurants
	
	Have restaraunt matching service between two users, as a 
	complement to the video feature in case users want to meet in-
	person instead

	Add location services and include back-end with data 
	functionality like Google Places or Yelp! API

	Create an algorithm to suggest places based on users 
	preferences and other relevant meta-data