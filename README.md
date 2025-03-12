# Garmin Zephyr Weather Data Field

Zephyr is a Connect IQ Data Field for Garmin Edge cycling computers that provides real-time wind and precipitation information based on your current location. Designed for cyclists who want to stay informed about weather conditions during their rides.

## Features

- **Current Wind Speed**: Displays wind speed in mph
- **Wind Direction**: Shows wind direction in degrees
- **Precipitation**: Indicates current or upcoming rain conditions
- **Automatic Updates**: Refreshes weather data every 15 minutes
- **GPS Positioning**: Uses your device's GPS to fetch local weather data

## Compatibility

Zephyr has been tested and confirmed to work on:
- Garmin Edge 530

Other Connect IQ capable Edge devices should work but have not been extensively tested.

## Usage

Once installed as a data field on your device:

1. Start an activity
2. The data field will automatically fetch weather data when GPS location is available
3. Information updates every 15 minutes to conserve battery and reduce API calls



### Reporting Issues

If you encounter problems, please file an issue on the [GitHub repository](https://github.com/MJV11/Zephyr/issues) with:

1. Your device model
2. Connect IQ software version
3. Steps to reproduce the issue
4. Any error messages displayed

## Privacy

Zephyr collects the following data to function:
- Your current GPS coordinates (to fetch local weather)

This data is:
- Only sent to the OpenWeatherMap API
- Not stored or logged by the app
- Not shared with any other services
- Not used for any purpose other than fetching current weather data

The application complies with Garmin's privacy policies and OpenWeatherMap's terms of service.

## Developer Information

### Technology Stack

Zephyr is built using:
- Monkey C language
- Garmin Connect IQ SDK
- OpenWeatherMap API for weather data

### API Usage

The app uses the OpenWeatherMap API with the following endpoints:
- Current weather data

### Building From Source

To build Zephyr from source:

1. Install the [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)
2. Clone this repository
3. Open the project in the Connect IQ IDE
4. Modify `manifest.xml` with your own application ID
5. Build the application using the IDE

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

Guidelines for contributing:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request with detailed description of changes

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- OpenWeatherMap for providing the weather data API
- Garmin for the Connect IQ platform
