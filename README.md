# Graph Convolutional Network (GCN) RTL Design

This project implements a hardware-oriented Graph Convolutional Network (GCN) accelerator in SystemVerilog.

The design focuses on processing graph-structured data using a sparse COO-based representation along with feature and weight memory access. The overall architecture combines transformation, combination, and selection stages to compute the final output addresses for each feature row.

The project is structured as a complete RTL design and simulation workflow, making it suitable for digital hardware design learning, verification, and portfolio presentation.

---

## Project Description

This GCN design consists of several hardware modules working together to perform the computation pipeline:

- `Transformation_Block`: reads feature and weight data and prepares row-wise intermediate values.
- `Combination_Block`: combines transformed values with COO-based adjacency information.
- `Argmax`: selects the maximum result for each node and produces the final output address.
- `GCN`: top-level module integrating the full pipeline.

The design follows a hardware dataflow model where sparse graph information and dense feature/weight data are processed through multiple computational stages before the final graph-level decision is made.

---

## Main Components

### Top-Level Module

```text
Starter RTL Code/GCN.sv
```

The top-level GCN module connects the main processing units and manages the data path between memory access, transformation, combination, and output selection.

### Transformation Stage

```text
Starter RTL Code/Transformation_Block.sv
Starter RTL Code/Transformation_FSM.sv
```

This stage handles the memory read requests and prepares intermediate data for the next processing step.

### Combination Stage

```text
Starter RTL Code/Combination_Block.sv
Starter RTL Code/Mult_ADJ.sv
Starter RTL Code/Vector_Multiplier.sv
```

This stage processes adjacency information and combines it with intermediate matrix results, producing values used for the final decision.

### Output Selection

```text
Starter RTL Code/Argmax.sv
```

The argmax block determines the final selected address for each row by comparing the computed candidate values and selecting the maximum result.

### Memory and Storage Modules

```text
Starter RTL Code/Matrix_FM_WM_Memory.sv
Starter RTL Code/Matrix_FM_WM_ADJ_Memory.sv
Starter RTL Code/Scratch_Pad_feature.sv
Starter RTL Code/Scratch_Pad_weight.sv
```

These modules handle the storage and retrieval of feature, weight, and adjacency data used during the computation.

---

## Repository Structure

```text
GCN/
├── Data/
│   ├── coo_data.txt
│   ├── feature_data.txt
│   ├── gold_address.txt
│   └── weight_data.txt
├── Starter RTL Code/
│   ├── Accumulator.v
│   ├── Argmax.sv
│   ├── Combination_Block.sv
│   ├── Feature_Counter.v
│   ├── FM_WM_ROW_Counter.sv
│   ├── GCN.sv
│   ├── GCN_TB.sv
│   ├── GCN_TB_post_syn_apr.sv
│   ├── Matrix_FM_WM_ADJ_Memory.sv
│   ├── Matrix_FM_WM_Memory.sv
│   ├── Mult_ADJ.sv
│   ├── Scratch_Pad_feature.sv
│   ├── Scratch_Pad_weight.sv
│   ├── Transformation_Block.sv
│   ├── Transformation_FSM.sv
│   └── Vector_Multiplier.sv
├── Lab4.pdf
├── README.md
├── .gitignore
└── Data/
```

---

## Data Inputs

The `Data/` folder contains the input files used by the simulation environment:

- `feature_data.txt`: feature matrix data
- `weight_data.txt`: weight matrix data
- `coo_data.txt`: COO-based graph representation
- `gold_address.txt`: expected output addresses used to verify correctness

These files are loaded by the testbench via `$readmemb` to simulate the GCN hardware pipeline.

---

## Verification

The verification flow is implemented in the testbench:

```text
Starter RTL Code/GCN_TB.sv
```

The testbench performs the following actions:

- Loads the feature, weight, COO, and golden output files
- Generates the clock and reset signals
- Starts the DUT execution
- Waits for the `done` signal
- Compares the design outputs against the golden reference values
- Displays the DUT result and expected result for each node

The verification logic checks whether each computed output address matches the expected golden address and raises an error if a mismatch is found.

---

## Simulation Flow

This project is designed for RTL simulation using a SystemVerilog testbench.

### Example simulation command

From the project directory:

```bash
cd "Starter RTL Code"
vsim -c work.GCN_TB -do "run -all; quit -f"
```

Or compile manually:

```bash
cd "Starter RTL Code"
vlog *.sv
vsim -c work.GCN_TB -do "run -all; quit -f"
```

The result should show whether the hardware output matches the expected golden addresses for all rows.

---

## Design Highlights

- Hardware implementation of a GCN-inspired dataflow
- Sparse graph processing using COO style adjacency representation
- Memory-based feature and weight access
- Intermediate transformation and combination stages
- Final argmax-based output decision
- Functional validation through a golden-reference testbench

---

## Future Improvements

Potential extensions for this project include:

- adding more instruction/graph operation support
- improving modularity and scalability
- integrating synthesis-friendly pipeline optimizations
- adding waveform visualization and performance analysis
- extending the design into a larger accelerator architecture

---

## License

This project is intended for educational and portfolio use.

---

## Author

Your Name
