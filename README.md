# Cielo

Cielo is a Flutter Web application that displays weather history and upcoming forecasts using the [Open-Meteo](https://open-meteo.com/) APIs.

The application focuses on making the requested weather information easy to scan for a selected period: temperature, apparent temperature, humidity, wind, precipitation, and cloud cover.

## Features

- Current weather summary for the selected city.
- Daily weather cards for past, current, and upcoming dates.
- Quick range filters: past 3 days, today, next 3 days, next 7 days, and the full loaded range.
- Custom date range selection with a date picker.
- Historical and forecast data retrieval through Open-Meteo.
- Default location set to Montpellier when no city is selected.
- No API key required.

## Bonus

The project includes a city search bar connected to the Open-Meteo Geocoding API.

Users can type a city name, select one of the suggested results, and the application reloads the weather data for the selected coordinates.

The application is also almost entirely responsive. The main remaining exception is the date picker/range selector bar, which still needs layout improvements on narrow screens.

## Tech Stack

- Flutter Web
- Dart
- Open-Meteo Forecast API
- Open-Meteo Historical Weather API
- Open-Meteo Geocoding API
- `http` for API calls
- `intl` for date formatting
- `syncfusion_flutter_datepicker` for custom range selection
- `google_fonts` for typography
- `fl_chart` is already declared and planned for the next chart feature

## Installation

Make sure Flutter is installed and available in your terminal.

This project requires a Dart SDK compatible with `3.11.5` as declared in `pubspec.yaml`.

Check your local versions:

```bash
dart --version
flutter --version
```

If your Flutter or Dart version is too old, update Flutter:

```bash
flutter upgrade
```

Then install the project dependencies:

```bash
flutter pub get
```

## Run the Application

Run the Flutter web app in Chrome:

```bash
flutter run -d chrome
```

You can also run it from Visual Studio Code by selecting a Chrome/Web target and using the Run command.

## How to Use

1. Open the application in the browser.
2. Use the search bar in the header to select a city. If no city is selected, Montpellier is used by default.
3. Choose one of the predefined forecast ranges or open the custom date range picker.
4. Read the current weather card and the daily weather cards for the selected period.

Each daily card displays:

- Minimum and maximum temperature
- Minimum and maximum apparent temperature
- Mean relative humidity
- Maximum wind speed
- Total precipitation
- Mean cloud cover
- Weather description based on the weather code

## Project Structure

- `lib/main.dart`: application entry point and main screen state.
- `lib/open_meteo_api.dart`: Open-Meteo forecast and archive API calls.
- `lib/geocoding_api.dart`: city search through Open-Meteo geocoding.
- `lib/models/`: typed weather and city models.
- `lib/widgets/`: UI components for the app bar, search bar, range selector, current weather, and daily forecasts.
- `lib/theme/`: shared colors and button styles.
- `assets/`: application icon and logo.

## Known Issues

- `ForecastRangeSelector` is not fully responsive yet and does not wrap onto two lines when horizontal space is too limited.
- Interface text is still hardcoded in French. Localization is not implemented yet.
- There is no dedicated error page when the API fails. Errors are currently shown inline.

## Planned Improvements

- Fix the known responsive layout and error handling issues.
- Add localization support instead of hardcoded French strings.
- Add keyboard navigation for city search suggestions.
- Add an `X` button to clear the city search input.
- Use the user's current location as the default location instead of Montpellier.
- Add a small `Passé` tag on weather cards that display historical data.
- Use `fl_chart` and the hourly data already fetched from the API to display charts for the different weather metrics by hour.
- Add tests for API response parsing and Open-Meteo API integration.

## Development Note

This is my first Flutter project. Because I also had school projects at the same time, I could not finish every improvement I wanted before the delivery deadline.

For the recruitment delivery, the `main` branch will remain unchanged. I will continue improving the project on the `dev` branch so interested reviewers can follow the next iterations separately.
