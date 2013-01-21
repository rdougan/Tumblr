# Tumblr for iPad

I originally started working on this app over 3 years ago - back when I had no idea what I was doing. There was no Tumblr app for iPad, so I wanted to create one.

3 years on (just before Christmas) I took a notion to start again, as Tumblr *still* had not released a new app. Unfortunately as it was finally coming together, Tumblr got their finger out of their asses and released a lovely iPad app.

## What exists in the project right now

* An almost complete Objective-C wrapper around the Tumblr API, which uses AFNetworking. Fetching and creating posts is all there, along with liking and fetching liked posts. You can also fetch posts for a specific blog.
* It also uses the Google OAuth1 authentication code to actually login.
* The app uses CoreData, so all the user data is 'automatically' stored. I have already created all the CoreData models for each of the Tumblr post types - this is a ridiculous amount of boilerplate code.
* A basic UI to:
	* login
	* show user information
	* show the user dashboard
	* show the users liked posts
	* show the users blogs
	* create new posts (only text has been implemented)
* A UICollectionViewController subclass which handles Tumblr post types. Post types supported right now are:

	* text
	* photos
	* photosets
	* quotes
	
	The other types will require some more work, but I believe photosets is the most difficult as you must calculate the positioning of each photo in the set.
	
## The current UI

I was planning on designing the UI with my beautiful wife [https://twitter.com/mrsdougan](Sarah Dougan), but of course that was also stopped because of the launch of the offical app.

The current UI is merely a demo of the functionality of the API.

#### Logged out

![logged out](http://f.cl.ly/items/3F0u0a3S133M1F2C100z/Screen%20Shot%202013-01-21%20at%2010.55.02%20PM.png)

#### Logged in

![user information](http://f.cl.ly/items/051n3J422G36310a0X0c/Screen%20Shot%202013-01-21%20at%2010.52.18%20PM.png)

#### Dashboard

![dashboard](http://f.cl.ly/items/2I3e1T390A0h0d0e451z/Screen%20Shot%202013-01-21%20at%2010.52.32%20PM.png)

#### Create Post View

![create post](http://f.cl.ly/items/073U0x1B3z2v3O3V2Q1p/Screen%20Shot%202013-01-21%20at%2010.52.36%20PM.png)
