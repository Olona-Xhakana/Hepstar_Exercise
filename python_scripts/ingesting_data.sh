#Cloned my github repo "https://github.com/Olona-Xhakana/Hepstar_Exercise" on a GCP project called Hepstar. 

bq mk INGESTION // Created a bigquey dataset ingestion, transformation, modelling and presentation.

# 1. Navigate to the raw data sample directory
cd "reference/Hepstar Data Engineering - Takehome exercise (raw data sample)"

# 2. Verify you see the CSVs on shell after cloning the repo
ls *.csv

# 3.Loop to ingest all 20+ tables
for file in *.csv; do
    # Clean the name (remove .csv, replace '-' and spaces with '_')
    clean_name=$(echo "$file" | sed 's/\.csv//' | sed 's/[- ]/_/g')
   
    echo "Ingesting $file -> INGESTION.$clean_name"
   
    bq load --source_format=CSV --autodetect --skip_leading_rows=1 \
      INGESTION."$clean_name" "$file"
done
