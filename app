import streamlit as st
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import io

# --- Page Configuration & Styling ---

st.set_page_config(layout="wide", page_title="Sortify", page_icon="📊")

def apply_custom_styling():
    """Applies custom CSS for a modern, high-contrast dark theme."""
    # Set Matplotlib style for dark charts
    plt.style.use('dark_background')
    plt.rcParams.update({
        "figure.facecolor": "#0E1117",
        "axes.facecolor": "#0E1117",
        "text.color": "#EDEDED",
        "axes.labelcolor": "#A0AEC0",
        "xtick.color": "#A0AEC0",
        "ytick.color": "#A0AEC0",
        "grid.color": "#444444"
    })
    
    st.markdown("""
        <style>
            /* --- Main App & Body --- */
            body {
                color: #CCCCCC; /* Default body text color */
            }
            .stApp {
                background-color: #0E1117;
            }
            .main .block-container {
                padding-top: 2rem;
                padding-bottom: 2rem;
            }
            
            /* --- Sidebar --- */
            [data-testid="stSidebar"] {
                background-color: #1A1A1A;
                border-right: 1px solid #222;
            }
            
            /* --- TYPOGRAPHIC HIERARCHY --- */
            /* Main Title */
            .title {
                font-size: 3rem !important;
                font-weight: bold !important;
                color: #FFFFFF !important; /* Pure white for max contrast */
                text-align: center !important;
            }
            /* Tagline */
            .tagline {
                font-size: 1.25rem !important;
                font-style: normal !important;
                color: #A0AEC0 !important; /* Softer, elegant subtitle color */
                text-align: center !important;
                margin-bottom: 2.5rem !important;
            }
            /* Section Headers (st.header) */
            h2 {
                font-size: 2rem !important;
                color: #00BFFF !important; /* Sky Blue accent for headers */
                font-weight: 600 !important;
                border-bottom: 2px solid #00BFFF;
                padding-bottom: 0.3rem;
                margin-top: 2rem;
            }
            /* Sidebar Headers */
            [data-testid="stSidebar"] h2 {
                color: #F0DB4F !important; /* Yellow accent for sidebar headers */
                border-bottom: none;
            }
            /* Sub-headers (st.subheader) */
            h3 {
                font-size: 1.6rem !important;
                color: #E5E5E5 !important;
                font-weight: 600 !important;
            }

            /* --- Containers & Widgets --- */
            /* Expander styling */
            .st-expander {
                border: 1px solid #333;
                border-radius: 10px;
                background-color: #1A1A1A;
            }
            .st-expander header {
                font-size: 1.25rem;
                font-weight: 600;
                color: #EDEDED;
            }
            /* Button styling */
            .stButton>button {
                border-radius: 8px;
                border: 2px solid #4FD1C5; /* Teal CTA color */
                color: #4FD1C5;
                background-color: transparent;
                transition: all 0.3s;
                font-weight: bold;
            }
            .stButton>button:hover {
                border-color: #4FD1C5;
                color: #1A1A1A;
                background-color: #4FD1C5;
            }
            /* Info/Warning boxes */
            .stAlert {
                border-radius: 8px;
            }
        </style>
    """, unsafe_allow_html=True)

# --- Data Loading & Caching ---

@st.cache_data
def load_data(uploaded_file):
    """Loads data from an uploaded file, caching the result."""
    try:
        if uploaded_file.name.endswith('.csv'):
            return pd.read_csv(io.BytesIO(uploaded_file.getvalue()))
        else:
            return pd.read_excel(io.BytesIO(uploaded_file.getvalue()), engine='openpyxl')
    except Exception as e:
        st.error(f"Error reading file: {e}")
        return None

# --- Helper Functions ---

def get_column_types(df):
    """Identifies numerical, categorical, and ID columns."""
    numerical_cols = df.select_dtypes(include=np.number).columns.tolist()
    categorical_cols = df.select_dtypes(include=['object', 'category']).columns.tolist()
    id_cols = [col for col in df.columns if 'id' in col.lower() or 'uuid' in col.lower()]
    # Refine numerical and categorical lists to exclude IDs
    numerical_cols = [col for col in numerical_cols if col not in id_cols]
    categorical_cols = [col for col in categorical_cols if col not in id_cols]
    return numerical_cols, categorical_cols, id_cols

def get_plot_recommendations(df, x_col, y_col):
    """Recommends plot types based on selected column data types."""
    if not x_col or not y_col:
        return []
    
    x_type = 'numerical' if pd.api.types.is_numeric_dtype(df[x_col]) else 'categorical'
    y_type = 'numerical' if pd.api.types.is_numeric_dtype(df[y_col]) else 'categorical'
    
    if x_type == 'numerical' and y_type == 'numerical':
        return ["Scatter Plot", "Line Plot", "Hexbin Plot"]
    if (x_type == 'categorical' and y_type == 'numerical') or (x_type == 'numerical' and y_type == 'categorical'):
        return ["Box Plot", "Violin Plot", "Bar Plot", "Strip Plot"]
    if x_type == 'categorical' and y_type == 'categorical':
        return ["Grouped Count Plot", "Heatmap"]
    return []

# --- Plotting Functions ---

def generate_plot(df, chart_type, x_col, y_col, hue_col):
    """Generates and displays the selected plot."""
    st.subheader(f"{chart_type}: {y_col} vs. {x_col}")
    fig, ax = plt.subplots(figsize=(12, 7))
    
    try:
        if chart_type == "Scatter Plot":
            sns.scatterplot(data=df, x=x_col, y=y_col, hue=hue_col, ax=ax)
            sns.regplot(data=df, x=x_col, y=y_col, scatter=False, ax=ax, color='#E53E3E') # Red accent for line
        elif chart_type == "Line Plot":
            plot_df = df.sort_values(by=x_col)
            sns.lineplot(data=plot_df, x=x_col, y=y_col, hue=hue_col, ax=ax)
        elif chart_type == "Hexbin Plot":
            ax.hexbin(df[x_col], df[y_col], gridsize=20, cmap='Blues')
        elif chart_type == "Box Plot":
            sns.boxplot(data=df, x=x_col, y=y_col, hue=hue_col, ax=ax)
        elif chart_type == "Violin Plot":
            sns.violinplot(data=df, x=x_col, y=y_col, hue=hue_col, ax=ax)
        elif chart_type == "Strip Plot":
            sns.stripplot(data=df, x=x_col, y=y_col, hue=hue_col, ax=ax, dodge=True)
        elif chart_type == "Bar Plot":
            sns.barplot(data=df, x=x_col, y=y_col, hue=hue_col, ax=ax, errorbar=None)
        elif chart_type == "Grouped Count Plot":
            sns.countplot(data=df, x=x_col, hue=y_col, ax=ax)
        elif chart_type == "Heatmap":
            contingency_table = pd.crosstab(df[x_col], df[y_col])
            sns.heatmap(contingency_table, annot=True, fmt='d', cmap='YlGnBu', ax=ax)
        
        plt.xticks(rotation=45, ha='right')
        plt.tight_layout()
        st.pyplot(fig)
    except Exception as e:
        st.error(f"Could not generate plot. Error: {e}")
    finally:
        plt.close(fig)

# --- UI Display Functions ---

def display_summary(df):
    """Displays an overall summary of the DataFrame."""
    num_rows, num_cols = df.shape
    total_missing = df.isnull().sum().sum()
    missing_percentage = (total_missing / (num_rows * num_cols)) * 100 if (num_rows * num_cols) > 0 else 0
    
    num_cols_list, cat_cols_list, id_cols_list = get_column_types(df)

    col1, col2 = st.columns(2)
    col1.metric("Total Rows", f"{num_rows:,}")
    col2.metric("Total Columns", f"{num_cols:,}")
    col1.metric("Numerical Columns", len(num_cols_list))
    col2.metric("Categorical Columns", len(cat_cols_list))
    st.metric("Total Missing Values", f"{total_missing:,} ({missing_percentage:.2f}%)")

def display_univariate_analysis(df):
    """Displays single-column (univariate) analysis."""
    for col in df.columns:
        with st.expander(f"Analysis of: {col}"):
            if pd.api.types.is_numeric_dtype(df[col]):
                st.dataframe(df[col].describe().to_frame().T)
                fig, ax = plt.subplots()
                sns.histplot(df[col].dropna(), kde=True, ax=ax)
                st.pyplot(fig)
                plt.close(fig)
            else:
                st.dataframe(df[col].value_counts().to_frame())

# --- Main Application ---

def main():
    """Main function to run the Sortify application."""
    apply_custom_styling()

    st.markdown('<p class="title">📊 Sortify</p>', unsafe_allow_html=True)
    st.markdown('<p class="tagline">From Sheets to Charts</p>', unsafe_allow_html=True)

    # --- Sidebar for Controls ---
    with st.sidebar:
        st.header("Upload Your Data")
        uploaded_file = st.file_uploader("Choose a CSV or Excel file", type=["csv", "xlsx", "xls"])
        
        if uploaded_file:
            df = load_data(uploaded_file)
            if df is not None:
                st.markdown("---")
                st.header("Build Your Chart")
                
                numerical_cols, categorical_cols, _ = get_column_types(df)
                all_cols = numerical_cols + categorical_cols
                
                x_col = st.selectbox("Select X-axis Column:", all_cols)
                y_col = st.selectbox("Select Y-axis Column:", all_cols, index=min(1, len(all_cols)-1))
                
                recommendations = get_plot_recommendations(df, x_col, y_col)
                all_plot_types = [
                    "Scatter Plot", "Line Plot", "Hexbin Plot", "Box Plot", 
                    "Violin Plot", "Strip Plot", "Bar Plot", "Grouped Count Plot", "Heatmap"
                ]
                
                chart_type = st.selectbox(
                    "Select Chart Type (Recommended first):", 
                    recommendations + ["---"] + [p for p in all_plot_types if p not in recommendations]
                )
                
                hue_col = st.selectbox("Select Hue/Grouping Column (Optional):", [None] + categorical_cols)
                
                generate_button = st.button("Generate Chart", use_container_width=True)
        else:
            df = None
            generate_button = False

    # --- Main Panel ---
    if df is None:
        st.info("Upload a file in the sidebar to get started!")
        return

    with st.expander("🚀 Quick Summary & Data Preview", expanded=True):
        col1, col2 = st.columns([1, 2])
        with col1:
            display_summary(df)
        with col2:
            st.dataframe(df.head())

    with st.expander("🔬 Single Column Deep Dive"):
        display_univariate_analysis(df)

    # --- Chart Display Area ---
    st.header("🎨 Chart Explorer")
    if generate_button:
        if chart_type and chart_type != "---":
            generate_plot(df, chart_type, x_col, y_col, hue_col)
        else:
            st.warning("Please select a valid chart type.")
    else:
        st.info("Configure your plot in the sidebar and click 'Generate Chart'.")


if __name__ == "__main__":
    main()
