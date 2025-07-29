# Sortify---From-Sheets-To-Charts
Sortify is a simple, no-code web app for instantly analyzing CSV and Excel files. Built for small-medium scale businesses, it automatically generates a comprehensive data profile, including summary statistics, histograms for numerical data, and bar charts for categorical data, helping you understand your dataset in seconds.


# Data Profile Report 📊

A simple, no-code web application for instantly analyzing and visualizing CSV and Excel files. Built for non-technical users, this tool automatically generates a comprehensive data profile, helping you understand your dataset in seconds.

This project was developed as part of a hackathon to make data analysis more accessible.

<img width="1919" height="900" alt="image" src="https://github.com/user-attachments/assets/785e109e-4117-45d2-8ad9-c9358980efec" />
<img width="1415" height="792" alt="image" src="https://github.com/user-attachments/assets/20aff4c7-4309-4fc6-bec8-1394f63849eb" />
<img width="1320" height="803" alt="image" src="https://github.com/user-attachments/assets/b00ac5cd-3a5c-4020-8f0a-04cec44731dc" />
<img width="1901" height="855" alt="image" src="https://github.com/user-attachments/assets/179b9987-1768-40f0-a25c-3f0c9e146790" />




---


## 🚀 Features

- ✅ Upload CSV/Excel files
- ✅ Auto-classify columns as **Numerical** or **Categorical**
- ✅ Identify missing values
- ✅ Summary statistics for numerical columns
- ✅ Column-wise null detection and info
- ✅ Dynamic chart generation:
  - Barplot
  - Lineplot
  - Scatter plot
  - Strip plot
  - Heatmap
  - Hexbin plot
  - FaceGrid visualization
- ✅ Supports combinations:
  - Categorical vs Categorical
  - Categorical vs Numerical
  - Numerical vs Numerical
- ✅ Responsive UI and dark/light mode support

---

## 🖼️ Live Preview

Check out the live demo 👉 [https://sortify.streamlit.app](https://sortify.streamlit.app)
## 🛠️ Tech Stack

* **Python:** The core programming language.
* **Streamlit:** For creating and serving the interactive web application.
* **Pandas:** For data manipulation and analysis.
* **Matplotlib & Seaborn:** For generating plots and visualizations.

---

## 🚀 Getting Started

Follow these instructions to get the project up and running on your local machine.

### Prerequisites

* Python 3.8 or higher

### Installation & Setup

1.  **Clone the repository (or download the files):**
    ```bash
    git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
    cd your-repo-name
    ```

2.  **Create a virtual environment (recommended):**
    ```bash
    # For Windows
    python -m venv venv
    venv\Scripts\activate

    # For macOS/Linux
    python3 -m venv venv
    source venv/bin/activate
    ```

3.  **Install the required packages:**
    Create a file named `requirements.txt` and add the following lines:
    ```
    streamlit
    pandas
    matplotlib
    seaborn
    openpyxl
    ```
    Then, install them using pip:
    ```bash
    pip install -r requirements.txt
    ```

### Running the Application

1.  **Launch the app from your terminal:**
    Make sure you are in the project directory where `app.py` is located.
    ```bash
    streamlit run app.py
    ```

2.  **View in your browser:**
    The command will open a new tab in your default web browser. If it doesn't, navigate to the **Local URL** displayed in the terminal (usually `http://localhost:8501`).

---

## 📖 How to Use

1.  **Run the application** using the command above.
2.  **Upload your data:** Drag and drop your CSV or Excel file onto the file uploader, or click to browse your local files.
3.  **View the analysis:** The app will instantly process the file and generate a report.
4.  **Explore your data:** Scroll down to see the detailed breakdown and visualizations for each column in your dataset.

---

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.


