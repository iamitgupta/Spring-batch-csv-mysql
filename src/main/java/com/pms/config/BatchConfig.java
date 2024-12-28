package com.pms.config;

import com.pms.entity.Product;
import com.pms.repository.ProductRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.job.builder.JobBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.batch.core.launch.support.RunIdIncrementer;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.step.builder.StepBuilder;
import org.springframework.batch.item.ItemWriter;
import org.springframework.batch.item.file.FlatFileItemReader;
import org.springframework.batch.item.file.mapping.BeanWrapperFieldSetMapper;
import org.springframework.batch.item.file.mapping.DefaultLineMapper;
import org.springframework.batch.item.file.transform.DelimitedLineTokenizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.transaction.PlatformTransactionManager;

@Configuration
@EnableBatchProcessing
@EnableScheduling
public class BatchConfig {

    private static final Logger logger = LoggerFactory.getLogger(BatchConfig.class);
    private static final int BATCH_SIZE = 100;
    private final JobLauncher jobLauncher;
    private final JobRepository jobRepository;
    private final PlatformTransactionManager batchTransactionManager;
    private final ProductRepository productRepository;

    public BatchConfig(JobLauncher jobLauncher, JobRepository jobRepository, PlatformTransactionManager batchTransactionManager, ProductRepository productRepository) {
        this.jobLauncher = jobLauncher;
        this.jobRepository = jobRepository;
        this.batchTransactionManager = batchTransactionManager;
        this.productRepository = productRepository;
    }

    @Bean
    public Job importProductJob() {
        return new JobBuilder("importProductJob", jobRepository).incrementer(new RunIdIncrementer()).start(chunkStep()).build();
    }

    @Bean
    public Step chunkStep() {
        return new StepBuilder("chunkStep", jobRepository).<Product, Product>chunk(BATCH_SIZE, batchTransactionManager).reader(reader()).writer(databaseWriter()).build();
    }

    @Bean
    public FlatFileItemReader<Product> reader() {
        FlatFileItemReader<Product> reader = new FlatFileItemReader<>();
        reader.setResource(new ClassPathResource("products.csv"));
        reader.setLineMapper(new DefaultLineMapper<Product>() {{
            setLineTokenizer(new DelimitedLineTokenizer() {{
                setNames("name", "description", "price");
            }});
            setFieldSetMapper(new BeanWrapperFieldSetMapper<Product>() {{
                setTargetType(Product.class);
            }});
        }});
        return reader;
    }

    @Bean
    public ItemWriter<Product> databaseWriter() {
        return items -> {
            logger.info("Writing {} products to DB", items.size());
            productRepository.saveAllAndFlush(items);
        };
    }

}
