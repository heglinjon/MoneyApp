# Money Application
# Developer's notes

## Approach

After reviewing the application requirements, I decided to continue Protocol oriented pattern implemented in the app, so every new implementation is following Protocol oriented rules. I tried to use Combine's most practical features. MVVM Design pattern is used in this app, so models and the view are related to each other in a reactive way. 

- MoneyService handles all API networking
- AccountStorage and TransactionStorage protocols persist data locally using UserDefaults
- AccountViewModel contains UI logic and state
- AccountView is the main SwiftUI view

In order to check internet connectivity Swift's built-in library Network is used. 

## Timeline:

- 1 hour on Thursday August 31st
- 1.5 hour on Friday September 1st
- 5.5 hour on Saturday September 2nd

notes: Bonus feature is added but I did not think that it would requires API request, so I've added label's texts statically. I would change them to put dynamically from the server side if time allows me.


Thanks for letting me participate in this meaningful take home test.
