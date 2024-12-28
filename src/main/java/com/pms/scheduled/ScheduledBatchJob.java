package com.pms.scheduled;

import lombok.AllArgsConstructor;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class ScheduledBatchJob {

    private JobLauncher jobLauncher;
    private Job importProductJob;

    @Scheduled(fixedRate = 60 * 60 * 1000)  // This will run every hour
    public void runBatchJob() {
        try {
            jobLauncher.run(importProductJob, new JobParametersBuilder()
                    .addString("timestamp", String.valueOf(System.currentTimeMillis()))
                    .toJobParameters());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
