package com.orbit.processor.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.orbit.processor.model.TelemetryRecord;

@Repository
public interface TelemetryRecordRepository extends JpaRepository<TelemetryRecord, Long> {
}