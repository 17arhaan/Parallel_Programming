
# **Functions**

## **1. MPI_Init**
```c
int MPI_Init(int *argc, char ***argv);
```
Initializes the MPI execution environment. This function must be called before any other MPI function.

---

## **2. MPI_Finalize**
```c
int MPI_Finalize();
```
Terminates the MPI execution environment. This function must be the last MPI call in a program.

---

## **3. MPI_Comm_rank**
```c
int MPI_Comm_rank(MPI_Comm comm, int *rank);
```
Determines the rank (process ID) of the calling process within the given communicator.

---

## **4. MPI_Comm_size**
```c
int MPI_Comm_size(MPI_Comm comm, int *size);
```
Determines the total number of processes within the given communicator.

---

## **5. MPI_Bcast**
```c
int MPI_Bcast(void *buffer, int count, MPI_Datatype datatype, int root, MPI_Comm comm);
```
Broadcasts a message from the root process to all other processes in the communicator.

---

## **6. MPI_Reduce**
```c
int MPI_Reduce(const void *sendbuf, void *recvbuf, int count, MPI_Datatype datatype,
               MPI_Op op, int root, MPI_Comm comm);
```
Performs a reduction operation (e.g., sum, max, min) on data distributed across processes and stores the result in the root process.

---

## **7. MPI_Scan**
```c
int MPI_Scan(const void *sendbuf, void *recvbuf, int count, MPI_Datatype datatype,
             MPI_Op op, MPI_Comm comm);
```
Performs a prefix reduction operation, where each process gets the result of the reduction operation up to its rank.

---

## **8. MPI_Gather**
```c
int MPI_Gather(const void *sendbuf, int sendcount, MPI_Datatype sendtype, 
               void *recvbuf, int recvcount, MPI_Datatype recvtype, 
               int root, MPI_Comm comm);
```
Collects data from all processes and gathers it into the root process.

---

## **9. MPI_Scatter**
```c
int MPI_Scatter(const void *sendbuf, int sendcount, MPI_Datatype sendtype, 
                void *recvbuf, int recvcount, MPI_Datatype recvtype, 
                int root, MPI_Comm comm);
```
Distributes data from the root process to all other processes in equal parts.

---

## **10. MPI_Barrier**
```c
int MPI_Barrier(MPI_Comm comm);
```
Synchronizes all processes in the communicator. Each process waits until all have reached this point.

---

## **11. MPI_Allreduce**
```c
int MPI_Allreduce(const void *sendbuf, void *recvbuf, int count, MPI_Datatype datatype,
                  MPI_Op op, MPI_Comm comm);
```
Performs a reduction operation across all processes and distributes the result to all.

---

## **12. MPI_Allgather**
```c
int MPI_Allgather(const void *sendbuf, int sendcount, MPI_Datatype sendtype, 
                  void *recvbuf, int recvcount, MPI_Datatype recvtype, 
                  MPI_Comm comm);
```
Collects data from all processes and distributes the full result to all processes.

---

## **13. MPI_Alltoall**
```c
int MPI_Alltoall(const void *sendbuf, int sendcount, MPI_Datatype sendtype, 
                 void *recvbuf, int recvcount, MPI_Datatype recvtype, 
                 MPI_Comm comm);
```
Each process sends data to all other processes and receives data from all other processes.

---

## **14. MPI_Send**
```c
int MPI_Send(const void *buf, int count, MPI_Datatype datatype, int dest, int tag, MPI_Comm comm);
```
Sends a message to a specific process.

---

## **15. MPI_Recv**
```c
int MPI_Recv(void *buf, int count, MPI_Datatype datatype, int source, int tag, MPI_Comm comm, MPI_Status *status);
```
Receives a message from a specific process.

---

## **16. MPI_Bsend (Buffered Send)**
```c
int MPI_Bsend(const void *buf, int count, MPI_Datatype datatype, int dest, int tag, MPI_Comm comm);
```
Sends a message using buffered mode, which allows a process to continue execution immediately after sending.

---

## **17. MPI_Buffer_attach**
```c
int MPI_Buffer_attach(void *buffer, int size);
```
Attaches a user-defined buffer for use with `MPI_Bsend`.

---

## **18. MPI_Buffer_detach**
```c
int MPI_Buffer_detach(void *buffer, int *size);
```
Detaches the buffer previously attached with `MPI_Buffer_attach`.

---

## **19. MPI_Isend**
```c
int MPI_Isend(const void *buf, int count, MPI_Datatype datatype, int dest, int tag, MPI_Comm comm, MPI_Request *request);
```
Initiates a non-blocking send operation.

---

## **20. MPI_Irecv**
```c
int MPI_Irecv(void *buf, int count, MPI_Datatype datatype, int source, int tag, MPI_Comm comm, MPI_Request *request);
```
Initiates a non-blocking receive operation.

---

## **21. MPI_Wait**
```c
int MPI_Wait(MPI_Request *request, MPI_Status *status);
```
Waits for a non-blocking send or receive operation to complete.

---

## **22. MPI_Waitall**
```c
int MPI_Waitall(int count, MPI_Request array_of_requests[], MPI_Status array_of_statuses[]);
```
Waits for all specified non-blocking operations to complete.

---

## **23. MPI_Errorhandler_set (Deprecated)**
```c
int MPI_Errorhandler_set(MPI_Comm comm, MPI_Errhandler errhandler);
```
Sets a custom error handler for a communicator. *Deprecated in MPI-2*.

---

## **24. MPI_Comm_set_errhandler**
```c
int MPI_Comm_set_errhandler(MPI_Comm comm, MPI_Errhandler errhandler);
```
Sets a custom error handler for a communicator. Replacement for `MPI_Errorhandler_set`.

---

## **25. MPI_Abort**
```c
int MPI_Abort(MPI_Comm comm, int errorcode);
```
Aborts all MPI processes in the communicator and terminates the program.

---
