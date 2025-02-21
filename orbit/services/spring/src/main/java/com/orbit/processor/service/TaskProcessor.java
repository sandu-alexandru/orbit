package com.orbit.processor.service;

import java.util.concurrent.CompletableFuture;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Service;

import com.orbit.processor.model.TelemetryRecord;
import com.orbit.processor.repository.TelemetryRecordRepository;

@Service
public class TaskProcessor {
    private static final Logger logger = LoggerFactory.getLogger(TaskProcessor.class);
    private static final String QUEUE_NAME = "telemetry_tasks_spring";

    @Autowired
    private TelemetryRecordRepository repository;

    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    @Bean
    public Queue telemetryQueue() {
        return new Queue(QUEUE_NAME, true); // Second parameter true means durable
    }

    @RabbitListener(queues = QUEUE_NAME)
    public void processTelemetry(String message) {
        try {
            logger.info("Received message: {}", message);

            TelemetryRecord record = new TelemetryRecord();
            record.setData(message);
            repository.save(record);

            CompletableFuture<SendResult<String, String>> future = 
                kafkaTemplate.send("telemetry_events", "Processed: " + message);
                
            future.whenComplete((result, ex) -> {
                if (ex == null) {
                    logger.info("Message sent successfully");
                } else {
                    logger.error("Failed to send message", ex);
                }
            });

        } catch (Exception e) {
            logger.error("Error processing message: {}", message, e);
            throw e;
        }
    }
}