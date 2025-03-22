import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
from supabase import create_client
import os
import logging

# Configure logging
logging.basicConfig(
    filename="logfile.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

try:
    # Load the monthly data
    df = pd.read_csv('2021.csv')
    logging.info("CSV file '2021.csv' loaded successfully.")
except Exception as e:
    logging.error(f"Error loading CSV file: {e}")
    raise SystemExit("Failed to load dataset, terminating script.")

# Function to validate that each crop has a maximum demand of 100%
def validate_max_percentages(weekly_df):
    try:
        logging.info("Validating max percentages for crops.")
        max_by_crop = weekly_df.groupby('crop_id')['demand'].max().reset_index()
        
        for _, row in max_by_crop.iterrows():
            logging.info(f"Crop {row['crop_id']}: {row['demand']}%")

        all_100 = all(max_by_crop['demand'] == 100)
        logging.info(f"All crops have 100% as maximum: {all_100}")
    except Exception as e:
        logging.error(f"Error in validate_max_percentages: {e}")

# Function to upload data to Supabase
def upload_to_supabase(df, table_name):
    try:
        logging.info(f"Starting upload to Supabase table '{table_name}'.")

        supabase_url = os.getenv("SUPABASE_URL")
        supabase_key = os.getenv("SUPABASE_API_KEY")

        if not supabase_url or not supabase_key:
            logging.error("Supabase credentials are missing!")
            raise SystemExit("Supabase credentials not found, terminating script.")

        supabase = create_client(supabase_url, supabase_key)

        records = df.to_dict('records')
        batch_size = 100

        for i in range(0, len(records), batch_size):
            batch = records[i:i + batch_size]
            result = supabase.table(table_name).insert(batch).execute()

            if hasattr(result, 'error') and result.error:
                logging.error(f"Error uploading batch {i // batch_size + 1}: {result.error}")
            else:
                logging.info(f"Uploaded batch {i // batch_size + 1}")

        logging.info("Upload completed.")
    except Exception as e:
        logging.error(f"Error in upload_to_supabase: {e}")

# Function to convert month-based data to week-based predictions
def month_to_week_predictions(df):
    try:
        logging.info("Generating weekly predictions.")

        month_to_weeks = {
            1: [1, 2, 3, 4], 2: [5, 6, 7, 8], 3: [9, 10, 11, 12, 13],
            4: [14, 15, 16, 17], 5: [18, 19, 20, 21, 22], 6: [23, 24, 25, 26],
            7: [27, 28, 29, 30, 31], 8: [32, 33, 34, 35], 9: [36, 37, 38, 39],
            10: [40, 41, 42, 43, 44], 11: [45, 46, 47, 48], 12: [49, 50, 51, 52]
        }

        weekly_data = []

        for crop_id in df['crop_id'].unique():
            logging.info(f"Processing crop_id {crop_id}.")
            
            crop_data = df[df['crop_id'] == crop_id]
            X = crop_data[['month_no']].values
            y = crop_data['demand'].values

            model = LinearRegression()
            model.fit(X, y)

            crop_weekly_demands = []

            for month in range(1, 13):
                monthly_demand = float(crop_data[crop_data['month_no'] == month]['demand'].values[0])
                weeks = month_to_weeks[month]
                num_weeks = len(weeks)

                for i, week in enumerate(weeks):
                    position_within_month = (i + 1) / (num_weeks + 1)
                    week_factor = 1.0 + (position_within_month - 0.5) * 0.05
                    weekly_demand = int(round((monthly_demand / num_weeks) * week_factor))

                    crop_weekly_demands.append({
                        'crop_id': crop_id, 'week_no': week, 'raw_demand': weekly_demand
                    })

            max_demand = max(item['raw_demand'] for item in crop_weekly_demands)

            for item in crop_weekly_demands:
                item['demand'] = round((item['raw_demand'] / max_demand) * 100, 2)
                del item['raw_demand']
                weekly_data.append(item)

        weekly_df = pd.DataFrame(weekly_data)
        
        weekly_df = weekly_df.sort_values(['crop_id', 'week_no']).reset_index(drop=True)
        weekly_df.insert(0, 'id', weekly_df.index + 1)

        logging.info(f"Generated weekly predictions for {len(weekly_df)} rows.")
        return weekly_df[['id', 'crop_id', 'week_no', 'demand']]
    
    except Exception as e:
        logging.error(f"Error in month_to_week_predictions: {e}")
        raise SystemExit("Prediction generation failed, terminating script.")

# Generate weekly predictions
weekly_df = month_to_week_predictions(df)
validate_max_percentages(weekly_df)

# Save weekly predictions
try:
    weekly_df.to_csv('weekly_demand_predictions_percentage.csv', index=False)
    logging.info("Weekly predictions saved to 'weekly_demand_predictions_percentage.csv'.")
except Exception as e:
    logging.error(f"Error saving predictions CSV: {e}")

# Function to plot multiple crops
def plot_multiple_crops(crop_ids=[1, 2, 3, 4, 5]):
    try:
        logging.info("Generating plots for multiple crops.")
        
        plt.figure(figsize=(14, 8))

        for crop_id in crop_ids:
            if crop_id in weekly_df['crop_id'].unique():
                crop_weekly = weekly_df[weekly_df['crop_id'] == crop_id]
                plt.plot(crop_weekly['week_no'], crop_weekly['demand'], 'o-', label=f'Crop {crop_id}')

        plt.xlabel('Week')
        plt.ylabel('Demand (% of Maximum per Crop)')
        plt.title('Weekly Demand Percentage for Multiple Crops')
        plt.ylim(0, 105)
        plt.grid(True)
        plt.legend()
        plt.tight_layout()
        plt.savefig('multiple_crops_demand_percentage.png')
        plt.close()
        
        logging.info("Plots saved as 'multiple_crops_demand_percentage.png'.")
    except Exception as e:
        logging.error(f"Error generating plots: {e}")

# Uncomment to plot multiple crops
# plot_multiple_crops(crop_ids=[1, 2, 3, 4, 5])

logging.info("Script execution completed.")
print("Done!")
