# cereopsis-custom-presentation
### An iOS app combining a storyboard with nibs and throwing in a custom presentation

I'm trying to find ways of bringing an existing app into the 21st Century by introducing a storyboard to launch the app and present the first screen or so, then drop back to loading nibs as is currently done. If this works as I hope, I can incrementally subsume the nibs into the storyboard rather than have the Big Bang thing going on. 

### Update
I'm pretty comfortable with where I've got to and that an app can indeed be gently migrated across from nibs to storyboards. Well, that's the theory. As always your mileage will vary.

### Update 2
Upgraded to Swift 3 syntax with very little fanfare and mostly handled by the migration process. There was a change in optionality which required attention but that's all. Happily, the move has fixed what was going to require some kind of hack and that was smoothing the transition of UINavigationBar height from 64 to 44 px and back (because of the unusual arrangement). However, this leaves me in the awkward position of having to either wait for GM and app submissions on Swift 3 or stick with 2.3 and implement the hack for a short time. 
