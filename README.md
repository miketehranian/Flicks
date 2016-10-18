# Project 2 - *Flicks*

**Flicks** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **14** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [ ] Implement segmented control to switch between list view and grid view.
- [x] Add a search bar.
- [x] All images fade in.
- [x] For the large poster, load the low-res image first, switch to high-res when complete.
- [x] Customize the highlight and selection effect of the cell.
- [x] Customize the navigation bar.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/3Vkda6p.gif' title='Application Walkthrough' width='' alt='Application Walkthrough' />
<img src='http://i.imgur.com/YTMEmn3.gif' title='Error Walkthrough' width='' alt='Network Error Walkthrough' />
<img src='http://i.imgur.com/rE5etJB.gif' title='Error Walkthrough' width='' alt='Network Error Walkthrough' />
<img src='http://i.imgur.com/sTqxwv0.gif' title='Error Walkthrough' width='' alt='Network Error Walkthrough' />
<img src='http://i.imgur.com/jgmknvi.gif' title='Error Walkthrough' width='' alt='Network Error Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

The hardest challenge I had was with the Search functionality because it required learning the Search bar delegate and the rules for filtering out movie records that matched the search text. In addition, I had to make sure the search bar had an adequate UX when moving to and from the detail view.

## License

    Copyright [2016] [Mike Tehranian]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
