// MongoDB Script for Analytics Collection
// This demonstrates Harness mongoshFile feature for external script execution

// Create analytics collection with time-series optimization
db.createCollection("analytics", {
    timeseries: {
        timeField: "timestamp",
        metaField: "metadata",
        granularity: "hours"
    }
});

// Create indexes for analytics queries
db.analytics.createIndex({ "metadata.userId": 1, timestamp: -1 });
db.analytics.createIndex({ "metadata.eventType": 1 });

// Insert sample analytics events
db.analytics.insertMany([
    {
        timestamp: new Date(),
        metadata: {
            userId: "user123",
            eventType: "page_view",
            page: "/dashboard"
        },
        value: 1
    },
    {
        timestamp: new Date(),
        metadata: {
            userId: "user456",
            eventType: "button_click",
            button: "submit"
        },
        value: 1
    }
]);

print("Analytics collection created with time-series support and sample data");
print("Indexes created for efficient querying");
