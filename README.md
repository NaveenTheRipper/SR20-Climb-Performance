# SR20-Climb-Performance

This repository contains a MATLAB script to analyze SR20 flight data including pressure altitude, true airspeed, rate of climb, and engine manifold pressure. The script also fits a quadratic curve to rate of climb vs airspeed to find optimal climb speeds Vy (best rate of climb) and Vx (best angle of climb).

## Files

- `flight_analysis.m` - MATLAB script for data analysis and plotting.

## Usage

1. Place your data files (`C_FLIGHT.CSV`, `C_SYSTEM.CSV`, `C_ENGINE.CSV`) in the same directory as the script.
2. Run the `flight_analysis.m` script in MATLAB.
3. The script will generate plots and display key climb performance metrics.

## Requirements

- MATLAB with the Statistics and Machine Learning Toolbox (for `movmean`)
- Data files in CSV format as specified in the script

## License

MIT License
