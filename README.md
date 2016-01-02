# WoboStaff

**Installation:** Add a valid HipChat API Token in the Config.plist file.

The app will retrieve the list of Wobo users using the HipChat API and it will group them by timezone.
The app also stores a local copy of the data retrieved and it will try to use it if there is no network connection available.

<div align="center">
        <img width="45%" height="640px" src="/../screenshots/sc1.jpg" alt="Sc1.jpg"</img>
        <img height="0" width="10px">
        <img width="45%" height="640px" src="/../screenshots/sc2.jpg" alt="Sc2.jpg"</img>
</div>


**TODO:**

1) Add more users information (online status, last online, etc)

2) Store a local copy of the images as well

3) When clicking on a specific user, open a new screen with more details (maybe allow to send a message)

4) Add a setting tab to add/update the API token from the app (at that point, this could be reworked into a generic HipChat app)
