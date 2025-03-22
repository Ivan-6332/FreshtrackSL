import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
from supabase import create_client
import os

# Load the monthly data
df = pd.read_csv('data.csv')


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

        # Temporary list to store all demand values for this crop
        crop_weekly_demands = []

        # Loop through each month and predict weekly demand
        for month in range(1, 13):
            # Get the monthly demand from the data
            monthly_demand = float(crop_data[crop_data['month_no'] == month]['demand'].values[0])

            # Get the weeks corresponding to this month
            weeks = month_to_weeks[month]
            num_weeks = len(weeks)

            # Create features for more precise weekly prediction
            for i, week in enumerate(weeks):
                # Create a weighted distribution for weeks within the month
                position_within_month = (i + 1) / (num_weeks + 1)  # Normalized position (0-1)

                # Predict demand for the specific week
                week_factor = 1.0 + (position_within_month - 0.5) * 0.1  # +/- 5% variation
                weekly_demand = (monthly_demand / num_weeks) * week_factor

                # Round to the nearest integer
                weekly_demand = int(round(weekly_demand))

                # Store the weekly demand for this crop
                crop_weekly_demands.append({
                    'crop_id': crop_id,
                    'week_no': week,
                    'raw_demand': weekly_demand  # Store the raw demand temporarily
                })

        # Calculate the maximum demand for THIS SPECIFIC CROP
        max_demand = max(item['raw_demand'] for item in crop_weekly_demands)

        # Update each entry with the percentage demand for this crop
        for item in crop_weekly_demands:
            percentage_demand = (item['raw_demand'] / max_demand) * 100
            # Round to 2 decimal places
            percentage_demand = round(percentage_demand, 2)

            # Replace raw demand with percentage demand
            item['demand'] = percentage_demand
            del item['raw_demand']

            # Add to the final weekly data list
            weekly_data.append(item)

    # Convert the list to a DataFrame
    weekly_df = pd.DataFrame(weekly_data)

    # Sort by crop_id and week_no
    weekly_df = weekly_df.sort_values(by=['crop_id', 'week_no'])

    # Add an ID column
    weekly_df['id'] = range(1, len(weekly_df) + 1)

    # Reorder columns
    weekly_df = weekly_df[['id', 'crop_id', 'week_no', 'demand']]

    return weekly_df


# Function to validate that each crop has a maximum demand of 100%
def validate_max_percentages(weekly_df):
    # Group by crop_id and find the maximum demand for each
    max_by_crop = weekly_df.groupby('crop_id')['demand'].max().reset_index()

    # Print validation summary
    print("Maximum percentage by crop_id:")
    for _, row in max_by_crop.iterrows():
        crop_id = row['crop_id']
        max_pct = row['demand']
        print(f"Crop {crop_id}: {max_pct}%")

    # Verify all maxes are 100%
    all_100 = all(max_by_crop['demand'] == 100)
    print(f"\nAll crops have 100% as maximum: {all_100}")

    # Count how many rows have 100% demand
    count_100 = len(weekly_df[weekly_df['demand'] == 100])
    print(f"Number of weeks with 100% demand: {count_100}")
    print(f"Number of unique crops: {weekly_df['crop_id'].nunique()}")


# Function to upload data to Supabase
def upload_to_supabase(df, table_name):
    # Supabase credentials
    supabase_url = "https://hjdrdccgsiefrvwttblm.supabase.co"
    supabase_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhqZHJkY2Nnc2llZnJ2d3R0YmxtIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0MTI1MTEzMCwiZXhwIjoyMDU2ODI3MTMwfQ.k6bC1LjLHcElkoiq5cYhJv3Y-U1AaD28bILQ-gTpZeE"

    # Create Supabase client
    supabase = create_client(supabase_url, supabase_key)

    # Convert DataFrame to list of dictionaries
    records = df.to_dict('records')

    # Upload data in batches to avoid hitting API limits
    batch_size = 100
    total_records = len(records)

    print(f"Uploading {total_records} records to Supabase table '{table_name}'...")

    for i in range(0, total_records, batch_size):
        batch = records[i:min(i + batch_size, total_records)]
        result = supabase.table(table_name).insert(batch).execute()

        # Check for errors
        if hasattr(result, 'error') and result.error:
            print(f"Error uploading batch {i // batch_size + 1}: {result.error}")
        else:
            print(f"Uploaded batch {i // batch_size + 1}/{(total_records - 1) // batch_size + 1}")

    print("Upload to Supabase completed.")


# Generate weekly predictions with percentage demand
weekly_df = month_to_week_predictions(df)

# Validate that each crop has at least one week with 100% demand
validate_max_percentages(weekly_df)

# Save the weekly predictions to a CSV file
weekly_df.to_csv('weekly_demand_predictions_percentage.csv', index=False)

print(f"Successfully generated weekly predictions as percentages for {len(weekly_df)} rows.")
print("Weekly percentage demand data saved to 'weekly_demand_predictions_percentage.csv'")


# Optional visualization to show percentage demand for multiple crops
def plot_multiple_crops(crop_ids=[1, 2, 3, 4, 5]):
    plt.figure(figsize=(14, 8))

    for crop_id in crop_ids:
        if crop_id in weekly_df['crop_id'].unique():
            # Filter data for the selected crop
            crop_weekly = weekly_df[weekly_df['crop_id'] == crop_id]
            plt.plot(crop_weekly['week_no'], crop_weekly['demand'], 'o-', label=f'Crop {crop_id}')

    plt.xlabel('Week')
    plt.ylabel('Demand (% of Maximum per Crop)')
    plt.title('Weekly Demand Percentage for Multiple Crops')
    plt.ylim(0, 105)  # Set y-axis to show 0-105%
    plt.grid(True)
    plt.legend()
    plt.tight_layout()
    plt.savefig('multiple_crops_demand_percentage.png')
    plt.close()


# Uncomment to generate a visualization for multiple crops
# plot_multiple_crops(crop_ids=[1, 2, 3, 4, 5])

# To upload to Supabase, uncomment and configure the following lines:

# Configure your Supabase credentials in the upload_to_supabase function above
# Then call the function with your table name
table_name = "demand"
upload_to_supabase(weekly_df, table_name)


print("Done!")