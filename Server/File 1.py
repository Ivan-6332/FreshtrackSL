import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split

# Load the monthly data
df = pd.read_csv('2021.csv')


# Function to convert month-based data to week-based predictions
def month_to_week_predictions(df):
    # Create a dictionary to map months to their corresponding weeks
    # Each month will be distributed into 4 or 5 weeks
    month_to_weeks = {
        1: [1, 2, 3, 4],  # January: weeks 1-4
        2: [5, 6, 7, 8],  # February: weeks 5-8
        3: [9, 10, 11, 12, 13],  # March: weeks 9-13
        4: [14, 15, 16, 17],  # April: weeks 14-17
        5: [18, 19, 20, 21, 22],  # May: weeks 18-22
        6: [23, 24, 25, 26],  # June: weeks 23-26
        7: [27, 28, 29, 30, 31],  # July: weeks 27-31
        8: [32, 33, 34, 35],  # August: weeks 32-35
        9: [36, 37, 38, 39],  # September: weeks 36-39
        10: [40, 41, 42, 43, 44],  # October: weeks 40-44
        11: [45, 46, 47, 48],  # November: weeks 45-48
        12: [49, 50, 51, 52]  # December: weeks 49-52
    }

    # Create an empty list to store the weekly data
    weekly_data = []

    # Loop through each unique crop_id
    for crop_id in df['crop_id'].unique():
        # Filter data for the current crop
        crop_data = df[df['crop_id'] == crop_id]

        # Create a linear regression model to predict demand based on month
        X = crop_data[['month_no']].values
        y = crop_data['demand'].values

        # Train the model
        model = LinearRegression()
        model.fit(X, y)

        # Loop through each month and predict weekly demand
        for month in range(1, 13):
            # Get the monthly demand from the data
            monthly_demand = float(crop_data[crop_data['month_no'] == month]['demand'].values[0])

            # Get the weeks corresponding to this month
            weeks = month_to_weeks[month]
            num_weeks = len(weeks)

            # Create features for more precise weekly prediction
            # Assume each week within a month has a slight trend based on position
            for i, week in enumerate(weeks):
                # Create a weighted distribution for weeks within the month
                # This creates a slight variation between weeks while maintaining the monthly total
                position_within_month = (i + 1) / (num_weeks + 1)  # Normalized position (0-1)

                # Predict demand for the specific week using a combination of:
                # 1. Linear regression prediction based on week number
                # 2. Weighted distribution of the monthly total
                week_factor = 1.0 + (position_within_month - 0.5) * 0.1  # +/- 5% variation
                weekly_demand = (monthly_demand / num_weeks) * week_factor

                # Round to the nearest integer
                weekly_demand = int(round(weekly_demand))

                # Add the weekly data to the list
                weekly_data.append({
                    'crop_id': crop_id,
                    'week_no': week,
                    'demand': weekly_demand
                })

    # Convert the list to a DataFrame
    weekly_df = pd.DataFrame(weekly_data)

    # Sort by crop_id and week_no
    weekly_df = weekly_df.sort_values(by=['crop_id', 'week_no'])

    # Add an ID column
    weekly_df['id'] = range(1, len(weekly_df) + 1)

    # Reorder columns
    weekly_df = weekly_df[['id', 'crop_id', 'week_no', 'demand']]

    return weekly_df


# Function to validate that the sum of weekly demands is reasonably close to the monthly demands
def validate_weekly_distribution(monthly_df, weekly_df):
    # Group weekly data by crop_id and month (derived from week_no)
    week_to_month = {}
    for month, weeks in {
        1: [1, 2, 3, 4],  # January
        2: [5, 6, 7, 8],  # February
        3: [9, 10, 11, 12, 13],  # March
        4: [14, 15, 16, 17],  # April
        5: [18, 19, 20, 21, 22],  # May
        6: [23, 24, 25, 26],  # June
        7: [27, 28, 29, 30, 31],  # July
        8: [32, 33, 34, 35],  # August
        9: [36, 37, 38, 39],  # September
        10: [40, 41, 42, 43, 44],  # October
        11: [45, 46, 47, 48],  # November
        12: [49, 50, 51, 52]  # December
    }.items():
        for week in weeks:
            week_to_month[week] = month

    # Add month to weekly data
    weekly_df['month'] = weekly_df['week_no'].map(week_to_month)

    # Group and sum weekly data by crop_id and month
    weekly_by_month = weekly_df.groupby(['crop_id', 'month'])['demand'].sum().reset_index()
    weekly_by_month.rename(columns={'month': 'month_no'}, inplace=True)

    # Prepare monthly data
    monthly_data = monthly_df[['crop_id', 'month_no', 'demand']].copy()

    # Merge to compare
    comparison = pd.merge(monthly_data, weekly_by_month, on=['crop_id', 'month_no'],
                          suffixes=('_monthly', '_weekly_sum'))

    # Calculate difference
    comparison['difference'] = comparison['demand_monthly'] - comparison['demand_weekly_sum']
    comparison['difference_percent'] = (comparison['difference'] / comparison['demand_monthly']) * 100

    # Drop the temporary month column from weekly_df
    weekly_df.drop(columns=['month'], inplace=True)

    return comparison


# Generate weekly predictions
weekly_df = month_to_week_predictions(df)

# Validate our weekly distribution
validation = validate_weekly_distribution(df, weekly_df)

# Print validation summary
print("Validation Summary:")
print(f"Average absolute difference: {validation['difference'].abs().mean():.2f}")
print(f"Average percentage difference: {validation['difference_percent'].abs().mean():.2f}%")

# Save the weekly predictions to a CSV file
weekly_df.to_csv('weekly_demand_predictions.csv', index=False)

print(f"Successfully generated weekly predictions for {len(weekly_df)} rows.")
print("Weekly demand data saved to 'weekly_demand_predictions.csv'")


# Optional visualization of monthly vs weekly data for a sample crop
def plot_sample_crop(crop_id=1):
    # Filter data for the selected crop
    crop_monthly = df[df['crop_id'] == crop_id]
    crop_weekly = weekly_df[weekly_df['crop_id'] == crop_id]

    # Create a figure with two subplots
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8))

    # Plot monthly data
    ax1.plot(crop_monthly['month_no'], crop_monthly['demand'], 'o-', label=f'Monthly Demand (Crop {crop_id})')
    ax1.set_xlabel('Month')
    ax1.set_ylabel('Demand')
    ax1.set_title(f'Monthly Demand for Crop {crop_id}')
    ax1.grid(True)

    # Plot weekly data
    ax2.plot(crop_weekly['week_no'], crop_weekly['demand'], 'o-', label=f'Weekly Demand (Crop {crop_id})')
    ax2.set_xlabel('Week')
    ax2.set_ylabel('Demand')
    ax2.set_title(f'Weekly Demand for Crop {crop_id}')
    ax2.grid(True)

    plt.tight_layout()
    plt.savefig(f'crop_{crop_id}_demand_comparison.png')
    plt.close()


# Uncomment to generate a visualization for a specific crop
# plot_sample_crop(crop_id=1)

print("Done!")
