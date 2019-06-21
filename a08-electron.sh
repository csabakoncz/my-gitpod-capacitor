#!/bin/bash



# Clone the repository
git clone https://github.com/electron/electron-quick-start
# Go into the repository
cd electron-quick-start
# Install dependencies
npm install


# this part not presently working! chrome-sandbox issues. See the notes.
#try


electron -- no-sanbox


# Run the app
#npm start
