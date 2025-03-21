import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split

# Load the monthly data
df = pd.read_csv('2021.csv')

# Function to convert month-based data to week-based predictions
def month_to_week_predictions(df):
    month_to_weeks = {
        1: [1, 2, 3, 4],
        2: [5, 6, 7, 8],
        3: [9, 10, 11, 12, 13],
        4: [14, 15, 16, 17],
        5: [18, 19, 20, 21, 22],
        6: [23, 24, 25, 26],
        7: [27, 28, 29, 30, 31],
        8: [32, 33, 34, 35],
        9: [36, 37, 38, 39],
        10: [40, 41, 42, 43, 44],
        11: [45, 46, 47, 48],
        12: [49, 50, 51, 52]
    }

    weekly_data = []

    for crop_id in df['crop_id'].unique():
        crop_data = df[df['crop_id'] == crop_id]
        X = crop_data[['month_no']].values
        y = crop_data['demand'].values

        model = LinearRegression()
        model.fit(X, y)

        for month in range(1, 13):
            monthly_demand = float(crop_data[crop_data['month_no'] == month]['demand'].values[0])
            weeks = month_to_weeks[month]
            num_weeks = len(weeks)

            for i, week in enumerate(weeks):
                position_within_month = (i + 1) / (num_weeks + 1)
                week_factor = 1.0 + (position_within_month - 0.5) * 0.1
                weekly_demand = (monthly_demand / num_weeks) * week_factor
                weekly_demand = int(round(weekly_demand))

                weekly_data.append({
                    'crop_id': crop_id,
                    'week_no': week,
                    'demand': weekly_demand
                })

    weekly_df = pd.DataFrame(weekly_data)
    weekly_df = weekly_df.sort_values(by=['crop_id', 'week_no'])
    weekly_df['id'] = range(1, len(weekly_df) + 1)
    weekly_df = weekly_df[['id', 'crop_id', 'week_no', 'demand']]

    return weekly_df

# Function to validate that the sum of weekly demands is reasonably close to the monthly demands
def validate_weekly_distribution(monthly_df, weekly_df):
    week_to_month = {}
    for month, weeks in {
        1: [1, 2, 3, 4],
        2: [5, 6, 7, 8],
        3: [9, 10, 11, 12, 13],
        4: [14, 15, 16, 17],
        5: [18, 19, 20, 21, 22],
        6: [23, 24, 25, 26],
        7: [27, 28, 29, 30, 31],
        8: [32, 33, 34, 35],
        9: [36, 37, 38, 39],
        10: [40, 41, 42, 43, 44],
        11: [45, 46, 47, 48],
        12: [49, 50, 51, 52]
    }.items():
        for week in weeks:
            week_to_month[week] = month

    weekly_df['month'] = weekly_df['week_no'].map(week_to_month)
    weekly_by_month = weekly_df.groupby(['crop_id', 'month'])['demand'].sum().reset_index()
    weekly_by_month.rename(columns={'month': 'month_no'}, inplace=True)

    monthly_data = monthly_df[['crop_id', 'month_no', 'demand']].copy()
    comparison = pd.merge(monthly_data, weekly_by_month, on=['crop_id', 'month_no'],
                          suffixes=('_monthly', '_weekly_sum'))

    comparison['difference'] = comparison['demand_monthly'] - comparison['demand_weekly_sum']
    comparison['difference_percent'] = (comparison['difference'] / comparison['demand_monthly']) * 100

    weekly_df.drop(columns=['month'], inplace=True)

    return comparison

# Generate weekly predictions
weekly_df = month_to_week_predictions(df)

# Validate our weekly distribution
validation = validate_weekly_distribution(df, weekly_df)

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
