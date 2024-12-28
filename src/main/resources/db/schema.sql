-- batch_job_execution_seq definition

CREATE TABLE `batch_job_execution_seq`
(
    `ID` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- batch_job_instance definition

CREATE TABLE `batch_job_instance`
(
    `JOB_INSTANCE_ID` bigint       NOT NULL,
    `VERSION`         bigint DEFAULT NULL,
    `JOB_NAME`        varchar(100) NOT NULL,
    `JOB_KEY`         varchar(32)  NOT NULL,
    PRIMARY KEY (`JOB_INSTANCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- batch_job_seq definition

CREATE TABLE `batch_job_seq`
(
    `ID` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- batch_step_execution_seq definition

CREATE TABLE `batch_step_execution_seq`
(
    `ID` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- batch_job_execution definition

CREATE TABLE `batch_job_execution`
(
    `JOB_EXECUTION_ID` bigint    NOT NULL,
    `VERSION`          bigint        DEFAULT NULL,
    `JOB_INSTANCE_ID`  bigint    NOT NULL,
    `CREATE_TIME`      timestamp NOT NULL,
    `START_TIME`       timestamp NULL DEFAULT NULL,
    `END_TIME`         timestamp NULL DEFAULT NULL,
    `STATUS`           varchar(10)   DEFAULT NULL,
    `EXIT_CODE`        varchar(20)   DEFAULT NULL,
    `EXIT_MESSAGE`     varchar(2500) DEFAULT NULL,
    `LAST_UPDATED`     timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`JOB_EXECUTION_ID`),
    KEY                `JOB_INSTANCE_EXECUTION_FK` (`JOB_INSTANCE_ID`),
    CONSTRAINT `JOB_INSTANCE_EXECUTION_FK` FOREIGN KEY (`JOB_INSTANCE_ID`) REFERENCES `batch_job_instance` (`JOB_INSTANCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- batch_job_execution_context definition

CREATE TABLE `batch_job_execution_context`
(
    `JOB_EXECUTION_ID`   bigint        NOT NULL,
    `SHORT_CONTEXT`      varchar(2500) NOT NULL,
    `SERIALIZED_CONTEXT` longtext,
    PRIMARY KEY (`JOB_EXECUTION_ID`),
    CONSTRAINT `JOB_EXEC_CTX_FK` FOREIGN KEY (`JOB_EXECUTION_ID`) REFERENCES `batch_job_execution` (`JOB_EXECUTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- batch_job_execution_params definition

CREATE TABLE `batch_job_execution_params`
(
    `JOB_EXECUTION_ID` bigint       NOT NULL,
    `PARAMETER_NAME`   varchar(100) NOT NULL,
    `PARAMETER_TYPE`   varchar(100) NOT NULL,
    `PARAMETER_VALUE`  varchar(2500) DEFAULT NULL,
    `IDENTIFYING`      char(1)      NOT NULL,
    KEY                `JOB_EXEC_PARAMS_FK` (`JOB_EXECUTION_ID`),
    CONSTRAINT `JOB_EXEC_PARAMS_FK` FOREIGN KEY (`JOB_EXECUTION_ID`) REFERENCES `batch_job_execution` (`JOB_EXECUTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- batch_step_execution definition

CREATE TABLE `batch_step_execution`
(
    `STEP_EXECUTION_ID`  bigint       NOT NULL,
    `VERSION`            bigint       NOT NULL,
    `STEP_NAME`          varchar(100) NOT NULL,
    `JOB_EXECUTION_ID`   bigint       NOT NULL,
    `CREATE_TIME`        timestamp    NOT NULL,
    `START_TIME`         timestamp NULL DEFAULT NULL,
    `END_TIME`           timestamp NULL DEFAULT NULL,
    `STATUS`             varchar(10)   DEFAULT NULL,
    `COMMIT_COUNT`       bigint        DEFAULT NULL,
    `READ_COUNT`         bigint        DEFAULT NULL,
    `FILTER_COUNT`       bigint        DEFAULT NULL,
    `WRITE_COUNT`        bigint        DEFAULT NULL,
    `READ_SKIP_COUNT`    bigint        DEFAULT NULL,
    `WRITE_SKIP_COUNT`   bigint        DEFAULT NULL,
    `PROCESS_SKIP_COUNT` bigint        DEFAULT NULL,
    `ROLLBACK_COUNT`     bigint        DEFAULT NULL,
    `EXIT_CODE`          varchar(20)   DEFAULT NULL,
    `EXIT_MESSAGE`       varchar(2500) DEFAULT NULL,
    `LAST_UPDATED`       timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`STEP_EXECUTION_ID`),
    KEY                  `JOB_EXECUTION_STEP_FK` (`JOB_EXECUTION_ID`),
    CONSTRAINT `JOB_EXECUTION_STEP_FK` FOREIGN KEY (`JOB_EXECUTION_ID`) REFERENCES `batch_job_execution` (`JOB_EXECUTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- batch_step_execution_context definition

CREATE TABLE `batch_step_execution_context`
(
    `STEP_EXECUTION_ID`  bigint        NOT NULL,
    `SHORT_CONTEXT`      varchar(2500) NOT NULL,
    `SERIALIZED_CONTEXT` longtext,
    PRIMARY KEY (`STEP_EXECUTION_ID`),
    CONSTRAINT `STEP_EXEC_CTX_FK` FOREIGN KEY (`STEP_EXECUTION_ID`) REFERENCES `batch_step_execution` (`STEP_EXECUTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;