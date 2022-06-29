# Requirements

Each implementation should contain following elements:

- MVVM architecture
- SwiftUI Lifecycle
- Single Activity pattern
- Repository pattern
- Material design components
- Swift Combine
- 3rd party libs - glide/picasso, lottie, google maps...

## Get Started

1. Read [Dev instructions](#general-development-checklist)
1. Clone new repository and checkout to new branch following rules described in dev instructions.
1. *Create new iOS project inside **application/** directory
   - Name: `CoronavirusApp`
   - Bundle identifier: `hr.dice._{gitlab_user_name}_.covidapp`
   - Minimum version: `13.0`
1. Update .gitignore (ignore editor files) before pushing project files to git
1. Push project files to new repository

 _\* Ignore XCode warning: `'application' already exist at the specified project location and it is not empty` - it should containt only .gitkeep file (can be deleted after project is initialized)_

## Coronavirus App

This project contains iOS code for educational task Coronavirus App

[Coronavirus API Postman Collection](/docs/Coronavirus_API.postman_collection.json)

[Figma design URL](https://www.figma.com/file/x3xBW37chFt373XeBqs0fy/Coronavirus-Tracker-App-UI-Kit?node-id=0%3A1)

## General development checklist

- Find ticket and assigne to yourself
- Set ticket state to "In Progress"
- Create feature branch from development branch
- The feature branch naming follows the pattern "feature/ticketnumber_description"
- Create a WIP-MR assigned to yourself, title of MR should start with #ticketnumber
- Implement the feature - every commit message should follow pattern:
   ```
   General name of change (e.g. Update changelog, Applied multiple suggestion from MR, Implemented feature _name_)

   - change 1
   - change 2
   - ...

   refs _#ticketnumber_
   ```
- If the feature is deemed complete, remove WIP, assign teammate as reviewer for MR and set ticket state to "In review"
- A feature can only be merged to develop after teammates approves
- After approve, delete the source branch and squash commits on merging, close ticket
- Pull remote dev branch changes to local dev branch and repeat the process

## Before requesting a Merge Request code review

- Check if title of MR is setup correct
- Add a description to MR, applying the appropriate template

## Additional notes

- API route "DayOneAllStatus" may return error (due to missing county). In that case call "ByCountryTotalStatus"


