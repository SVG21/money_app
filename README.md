# money_app

MoneyApp is a Flutter application designed to manage personal finances, including features such as currency conversion, transaction management, and balance top-up. The app uses the Riverpod state management solution to handle state efficiently and follows the MVC (Model-View-Controller) pattern to maintain a clean and modular codebase.

# Features

•	Currency Converter: Convert amounts between different currencies using real-time exchange rates.
•	Transaction Management: Add, view, and manage your transactions (payments and top-ups).
•	Balance Management: View and manage your current balance with top-up and payment functionalities.
•	Persistent Data: Transactions are stored locally using shared preferences.

#Project Structure

The project follows the MVC (Model-View-Controller) pattern, and the folder structure is organized as follows:
•	lib/core: Contains core components like colors, text styles, widgets, and utilities.
•	lib/features: Each feature (e.g., home, pay, top-up, currency converter) has its own folder, containing controllers, models, and views.
•	test/features: Contains unit and widget tests for each feature to ensure functionality and reliability.

#State Management

The project uses Riverpod for state management. Riverpod is a popular state management library that is safe, testable, and easy to use with the Flutter framework. It allows us to handle state changes efficiently and ensures that the app is scalable and maintainable.
Why Riverpod with MVC?
We chose Riverpod in conjunction with the MVC pattern for the following reasons:
•	Separation of Concerns: The MVC pattern helps in separating the business logic (Controller) from the UI (View) and the data models (Model). This separation makes the code more organized, reusable, and easier to maintain.
•	Simplified State Management: Riverpod simplifies state management by making the state immutable and ensuring that state updates are predictable. This is particularly useful in managing the state across various screens and features.
•	Modularity and Scalability: The combination of Riverpod and MVC makes the application modular and scalable, allowing developers to add new features or modify existing ones with ease.

#How Controllers Help Manage State

In the MoneyApp, controllers play a crucial role in managing state by acting as intermediaries between the UI (Views) and the data (Models). Here's how controllers help:
•	Centralized State Management: Controllers in Riverpod (StateNotifier and StateProvider) manage the state of different features centrally. For example, HomeController manages the balance and transaction state, while PayController and TopUpController manage payment and top-up functionalities.
•	Business Logic Encapsulation: All business logic, such as validating payment amounts, updating balances, and adding transactions, is handled within controllers. This ensures that the UI remains clean and focused on presentation, with no direct handling of data manipulation.
•	Reactive UI Updates: By using Riverpod, controllers can notify listeners (UI components) when there is a change in state. This ensures that the UI is always up-to-date with the latest data without manually managing state changes.
•	Testable and Maintainable Code: Controllers are highly testable as they contain the core logic of the application. This separation makes it easier to write unit tests for each controller to ensure they perform the intended operations without side effects.

#Packages Used

•	flutter_riverpod: State management solution used to manage the state of the application efficiently.
•	shared_preferences: Provides persistent storage for simple data, such as user preferences and settings, allowing data to be stored locally on the device.
•	http: Used for making HTTP requests, particularly for fetching real-time currency exchange rates.
•	flutter_test: Used for unit and widget testing to ensure code reliability and functionality.

#Shared Preferences

Shared Preferences is used in this project to persist user data locally on the device. This is particularly useful for:
•	Storing and retrieving transaction data so that users can see their transaction history even after restarting the app.
•	Maintaining user settings and preferences.
This allows for a better user experience, as the data remains consistent and accessible across sessions.

#Testing
The project includes comprehensive unit tests and widget tests to ensure the correctness and reliability of the codebase.
•	Unit Tests: Focus on testing the business logic, such as controllers and utility functions. For example, testing if the balance is correctly updated after a payment or top-up.
•	Widget Tests: Focus on testing the UI components to ensure that they behave as expected. For instance, checking if the currency conversion screen displays the correct exchange rate.

#Running Tests

To run all tests:

flutter test


