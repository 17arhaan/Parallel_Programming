
# Parallel Programming using C

This repository contains various examples and implementations of parallel programming using C, specifically focusing on parallel computer architecture and programming techniques using the **Message Passing Interface (MPI)**. The goal is to demonstrate different parallel computing paradigms and their applications in C programming.
</br>
## Functions ---> [Functions](functions.md)

</br>
## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Prerequisites](#prerequisites)
4. [Code Structure](#code-structure)
5. [How to Run](#how-to-run)
6. [Examples](#examples)
7. [Contributing](#contributing)
8. [License](#license)

## Introduction

Parallel programming allows for efficient computation by leveraging multiple processors to divide work and execute tasks simultaneously. This repository includes a variety of parallel programming examples that use MPI to solve different computational problems in parallel.

The repository covers a range of topics, such as:

- Basic parallel programming techniques using MPI.
- Collective communication operations like `MPI_Scatter`, `MPI_Gather`, and `MPI_Bcast`.
- Synchronization techniques and data distribution across processes.
- Practical problems like array manipulation, matrix operations, and reduction operations.

## Getting Started

To start working with this repository, you will need an MPI environment configured on your machine. This can be done using MPI implementations such as **OpenMPI** or **MPICH**.

### Prerequisites

- **C Compiler**: A C compiler (e.g., `gcc`).
- **MPI Implementation**: An MPI implementation like **OpenMPI** or **MPICH**.
  - Install OpenMPI:  
    ```bash
    sudo apt-get install openmpi-bin openmpi-common libopenmpi-dev
    ```
  - Install MPICH:
    ```bash
    sudo apt-get install mpich
    ```

### Required Libraries

- `mpi.h`: Header for the MPI functions used in the code.
- `stdio.h`: Standard input-output operations.
- `stdlib.h`: Memory allocation and utility functions.

### Installation

Clone the repository to your local machine:

```bash
git clone https://github.com/17arhaan/Parallel_Programming.git
cd Parallel_Programming
```

Ensure you have an MPI environment set up before running the code.

## Code Structure

The code is organized into different MPI examples and algorithms, each focusing on a particular concept in parallel programming.

- `evenodd.c`: Basic MPI communication (Send/Receive).
- `vowels.c`: Collective communication (e.g., `MPI_Bcast`, `MPI_Gather`).

## How to Run

Once the environment is set up, you can compile and run the MPI programs as follows:

### Compile the Code

```bash
mpicc example1.c -o example1
```

### Run the Code

To execute the compiled program with multiple processes, use the following command:

```bash
mpirun -np <number_of_processes> ./example1
```

Replace `<number_of_processes>` with the number of processes you want to use. For example, to run with 4 processes:

```bash
mpirun -np 4 ./example1
```

### Example Commands:

1. To compile and run `example1.c` with 4 processes:
   ```bash
   mpicc example1.c -o example1
   mpirun -np 4 ./example1
   ```

2. To compile and run `example2.c` with 8 processes:
   ```bash
   mpicc example2.c -o example2
   mpirun -np 8 ./example2
   ```

### Debugging (Optional)

To run the code with debugging enabled, use the following command:

```bash
mpirun -np <number_of_processes> gdb ./example1
```

## Examples

Below are some examples of the problems and how they can be run:

### Example 1: Array Manipulation

This example demonstrates how to manipulate an array in parallel, replacing even elements with `1` and odd elements with `0`. The array is divided among multiple processes using `MPI_Scatter`, and the modified array is gathered back using `MPI_Gather`.

#### Compile and Run:

```bash
mpicc example1.c -o example1
mpirun -np 4 ./example1
```

### Example 2: Matrix Multiplication

This example demonstrates parallel matrix multiplication. It distributes matrix rows across processes, performs local multiplications, and gathers the results at the root process.

#### Compile and Run:

```bash
mpicc example2.c -o example2
mpirun -np 4 ./example2
```

## Contributing

We welcome contributions to enhance the functionality and examples in this repository. Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Create a pull request.

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
