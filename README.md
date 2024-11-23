### Each folder (Study1, Study2) contains the source code for the study represented in the paper.

In each folder, you can find the prompt code for 4 approaches (baseline prompting, demo prompting, omni prompting, and persona_driven_prompting).  
For reproducibility, we also uploaded the dataset.

---

### File Paths and Configuration

Most of the uploaded code matches the file paths specified in the repository. However, some file paths, including the **API_KEY**, will require configuration.

### Accessing Results

The results presented in the paper can be accessed without running the code.

#### LLM Responses:
- The LLM responses for each approach can be found in the **llm_responses.csv** file.
  - For **Study1**, located in: `Study1/data/~~prompting/`
  - For **Study2**, located in: `Study2/Data_Case{}/~~prompting/`

#### Groundtruth (Human Responses):
- The actual human responses (groundtruth) can be found in:
  - **Study1**: `dv_total.csv` and `idv_total.csv`
  - **Study2**: Excel (xlsx) file

### All Results in the Paper
Not only the LLM responses but also all the results reported in the paper can be found in the repository. These are located in the **analysis_result** folder in **Study1** and **Study2**.

- **JS-divergence & Wasserstein distance**: Available in the `metrics.csv` file.
- **KDE distribution**: Graphs for each item are saved in the **KDE distribution** folder.
- **PLS-SEM**: Found in the **PLS-SEM** folder.
- **Consistency analysis**: Available in **appendix/consistency_analysis**.

### PLS-SEM Data for Paper Results:
To verify the data used in the paper for **PLS-SEM**:
1. Check the **Mean.boot** and **std** values in the **~~plssem.csv** file at the specified [path].
2. Check the **p-value** in the **~~plssem.txt** file.

By reviewing steps 1 and 2, all results reported in the paper’s tables can be verified.

### Viewing Results via Jupyter Notebooks

In addition to the CSV files, you can also directly view the results with Jupyter Notebook files in the **code** folder.  
