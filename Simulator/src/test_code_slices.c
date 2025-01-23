#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>

void get_slices(double current_time, int job_length, int *current_slice, int **slice_indices, double **proportions, int *num_slices) {
    //~ printf("%f\n", current_time);   
   
    //~ int start_time = (int)current_time;
    double start_time = current_time;
    double end_time = start_time + job_length;
    
    
    // Compute the slice indices where the job starts and ends
    int start_slice = (int)(start_time / 3600);    // The slice where the job starts
    int end_slice = (int)((end_time - 1) / 3600);  // The slice where the job ends
    
    // Ensure the slice indices are within the range [0, 8759]
    start_slice %= 8760;   // Loop back if slice is greater than 8759
    end_slice %= 8760;
    bool will_go_over = false;
    
    // same for the time
    start_time = fmod(start_time, 8760.0 * 3600.0);
    end_time = fmod(end_time, 8760.0 * 3600.0);
    
    if (end_time < start_time) {
        will_go_over = true;
    }
    
    // Handle the case when the job spans the end of the year (wraps to slice 0)
    if (end_slice >= start_slice) {
        *num_slices = end_slice - start_slice + 1;
    } else {
        *num_slices = 8760 - start_slice + end_slice + 1;
    }

    // Allocate memory for slice indices and proportions
    *slice_indices = malloc(*num_slices * sizeof(int));
    *proportions = malloc(*num_slices * sizeof(double));

    if (!*slice_indices || !*proportions) {
        perror("Failed to allocate memory");
        exit(1);
    }
    bool next_is_loop_back = false;
    // Fill the slice indices and proportions arrays
    for (int i = 0; i < *num_slices; i++) {
        // Wrap around the slice index using modulo
        int slice_index = (start_slice + i) % 8760;
        double slice_start = slice_index * 3600;
        double slice_end = slice_start + 3600;
        
        double overlap_start = 0;
        double overlap_end = 0;
        if (next_is_loop_back == true) {
            overlap_start = slice_start;
        }
        else {
            // Calculate the overlap with the current slice
            overlap_start = (start_time > slice_start) ? start_time : slice_start;
        }
        if (will_go_over == true && next_is_loop_back == false) {
            overlap_end = slice_end;
        }
        else {
            overlap_end = (end_time < slice_end) ? end_time : slice_end;
        }
        double overlap_duration = overlap_end - overlap_start;
        // Calculate the proportion of the slice that is used
        (*slice_indices)[i] = slice_index;
        (*proportions)[i] = overlap_duration / job_length;
        
        if (slice_index == 8759) { 
            next_is_loop_back = true; 
            end_time = job_length - (31536000.0 - start_time); 
        }
    }

    // Determine the current slice in which the job is located
    *current_slice = start_slice;
}

int main() {
    double current_time = 2147794581.83;
    int job_length = 455964;  // Job duration in seconds
    int *slice_indices = NULL;
    double *proportions = NULL;
    int num_slices;
    int current_slice;

    // Get the slices and proportions
    get_slices(current_time, job_length, &current_slice, &slice_indices, &proportions, &num_slices);

    // Print the current slice and the slices the job spans
    printf("Job starts at %.2f seconds and lasts %d seconds.\n", current_time, job_length);
    printf("The job starts in slice %d.\n", current_slice);

    for (int i = 0; i < num_slices; i++) {
        printf("Slice %d: %.2f%% of the job\n", slice_indices[i], proportions[i] * 100);
    }

    // Free the memory
    free(slice_indices);
    free(proportions);

    return 0;
}
