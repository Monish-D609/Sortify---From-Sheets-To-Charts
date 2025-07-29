import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import io

def analyze_dataframe(df):
    """
    Analyzes a Pandas DataFrame to identify column types, null values,
    and generate appropriate visualizations.

    Args:
        df (pd.DataFrame): The DataFrame to analyze.
    """
    st.header("Data Analysis Report")

    for col in df.columns:
        st.subheader(f"Column: {col}")

        # --- Column Type Detection ---
        if pd.api.types.is_numeric_dtype(df[col]):
            col_type = "Numerical"
        else:
            col_type = "Categorical"
        st.write(f"**Column Type:** {col_type}")

        # --- Null Value Analysis ---
        null_count = df[col].isnull().sum()
        st.write(f"**Missing Values:** {null_count} ({null_count / len(df):.2%})")

        # --- Analysis based on column type ---
        if col_type == "Numerical":
            # --- Summary Statistics ---
            st.write("**Summary Statistics:**")
            st.write(df[col].describe())

            # --- Histogram ---
            st.write("**Histogram:**")
            fig, ax = plt.subplots()
            sns.histplot(df[col].dropna(), kde=True, ax=ax)
            plt.xlabel(col)
            plt.ylabel("Frequency")
            st.pyplot(fig)
            plt.close(fig) # Close the figure to free memory

        else: # Categorical
            # --- Value Counts Bar Chart ---
            st.write("**Value Counts:**")
            value_counts = df[col].value_counts()
            
            if not value_counts.empty:
                st.write(value_counts)
                st.write("**Bar Chart:**")
                fig, ax = plt.subplots()
                # Plot only top 20 categories for readability if there are too many
                top_n = min(len(value_counts), 20)
                sns.barplot(x=value_counts.head(top_n).index, y=value_counts.head(top_n).values, ax=ax)
                plt.xlabel(col)
                plt.ylabel("Count")
                plt.xticks(rotation=45, ha='right')
                st.pyplot(fig)
                plt.close(fig) # Close the figure to free memory
            else:
                st.write("No data to display.")
        
        st.markdown("---") # Separator between columns


def main():
    """
    Main function to run the Streamlit application.
    """
    st.set_page_config(layout="wide")
    st.title("📊 CSV & Excel Data Visualizer")
    
    st.sidebar.header("Instructions")
    st.sidebar.info(
        "1. **Upload your data:** Use the file uploader below to upload a CSV or Excel file.\n"
        "2. **View analysis:** The app will automatically analyze the data and display insights.\n"
        "3. **Explore:** Scroll through the report to see summary statistics and charts for each column."
    )

    uploaded_file = st.file_uploader("Choose a CSV or Excel file", type=["csv", "xlsx", "xls"])

    if uploaded_file is not None:
        try:
            # To read file as bytes:
            file_bytes = uploaded_file.getvalue()
            
            if uploaded_file.name.endswith('.csv'):
                # For CSV, read directly from the bytes
                df = pd.read_csv(io.BytesIO(file_bytes))
            else:
                # For Excel, use BytesIO with openpyxl engine
                df = pd.read_excel(io.BytesIO(file_bytes), engine='openpyxl')

            st.success("File uploaded and processed successfully!")
            
            st.header("Data Preview")
            st.dataframe(df.head())
            
            analyze_dataframe(df)

        except Exception as e:
            st.error(f"Error processing file: {e}")

if __name__ == "__main__":
    main()
