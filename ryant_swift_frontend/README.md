# Swift mobile app for CS 4261 First Assignment

### Requirements:
- A mac running macOS 10.15.4 or higher
- Xcode 12.5.1 (you will need about 40 GB or higher of free disk space to install this)

### Technologies used:
- This application uses Swift 5. For more information, view the Swift's [documentation](https://developer.apple.com/documentation/swift).
- This application's UI uses storyboards and UIKit. For more information, view the storyboard [documentation](https://developer.apple.com/documentation/uikit/uistoryboard) and the UIKit [documentation](https://developer.apple.com/documentation/uikit).

### Intallation
- Download and install Xcode 12.5.1. You will need about 40 GB or more of free space on your computer to do this.
- Next, navigate to an empty folder on your computer and clone the repository ```git clone https://github.com/jacksanniota/flutter-programming.git```
- To open up the application, open Xcode, select “Open a project or file” and navigate into the repo. The project is located at flutter-programming/ryant_swift_frontend/First_Programming_Assignment/First_Programming_assignment.xcodeproj. Open the .xcodeproj file
- Once open, Xcode will process a series of files and do some setting up. After this is complete, select a simulator to run the application on, and press the play button. The application will begin running. To run on a real device, refer to [here](https://developer.apple.com/library/archive/documentation/ToolsLanguages/Conceptual/Xcode_Overview/RunningonaDevice.html) and [here](https://steemit.com/xcode/@ktsteemit/xcode-free-provisioning).

### Application Architecture
- This application has a "UI_Layer" and a "Business_Layer"
- The "UI_Layer" consists of the storyboards, images, view controllers, views, and anything else that pertains to UI
- The "Business_Layer" contains all of the business logic. It has 2 primary types of classes: Models and Taskers
- Models are objects that hold information and have a 1 to 1 relationship with the database models from the Django API. We have a <strong>User</strong> and a <strong>UserPosting</strong> model.
- Taskers are objects that perform tasks. These include things like making web calls, retrieving UserPostings, upvoting a post, downvoting a post, creating a post, logging a user in and out, or registering a user. We have a <strong>UserTasker</strong>, a <strong>UserPostingTasker</strong>, and a <strong>WebCallTasker</strong>.
