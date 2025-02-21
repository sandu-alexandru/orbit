#include <iostream>
#include <chrono>
#include <thread>
#include <string>
#include <atomic>
#include <memory>
#include <amqpcpp.h>
#include <amqpcpp/libboostasio.h>
#include <boost/asio.hpp>

std::atomic<bool> running{true};

class ConnectionHandler : public AMQP::LibBoostAsioHandler {
private:
    boost::asio::io_context& _ioContext;

public:
    ConnectionHandler(boost::asio::io_context& ioContext) : 
        AMQP::LibBoostAsioHandler(ioContext), _ioContext(ioContext) {}

    void onError(AMQP::TcpConnection *connection, const char *message) override {
        std::cerr << "AMQP error: " << message << std::endl;
        running = false;
    }

    void onClosed(AMQP::TcpConnection *connection) override {
        std::cout << "AMQP connection closed" << std::endl;
        running = false;
    }
};

void onMessage(const AMQP::Message &message, uint64_t deliveryTag, bool redelivered) {
    std::string body(message.body(), message.bodySize());
    std::cout << "Received: " << body << std::endl;
    
    // Simulate heavy computation
    std::this_thread::sleep_for(std::chrono::seconds(2));
    
    std::cout << "Processed: " << body << std::endl;
}

int main() {
    try {
        boost::asio::io_context ioContext;
        ConnectionHandler handler(ioContext);
        
        // Keep connection and channel objects alive
        std::unique_ptr<AMQP::TcpConnection> connection;
        std::unique_ptr<AMQP::TcpChannel> channel;
        
        int maxRetries = 5;
        int retryCount = 0;
        bool connected = false;

        while (!connected && retryCount < maxRetries) {
            try {
                std::cout << "Attempting to connect to RabbitMQ (attempt " << retryCount + 1 << "/" << maxRetries << ")..." << std::endl;
                
                AMQP::Address address("amqp://guest:guest@orbit-rabbitmq/");
                connection = std::make_unique<AMQP::TcpConnection>(&handler, address);
                channel = std::make_unique<AMQP::TcpChannel>(connection.get());

                // Setup channel error handler
                channel->onError([](const char* message) {
                    std::cerr << "Channel error: " << message << std::endl;
                    running = false;
                });

                // Declare queue and start consuming
                channel->declareQueue("telemetry_tasks_cpp", AMQP::durable)
                    .onSuccess([&channel](const std::string& name, uint32_t messagecount, uint32_t consumercount) {
                        std::cout << "Queue declared: " << name << std::endl;
                        channel->consume(name)
                            .onReceived(onMessage)
                            .onSuccess([]() {
                                std::cout << "Consumer started successfully" << std::endl;
                            });
                    });

                connected = true;
                std::cout << "Successfully connected to RabbitMQ" << std::endl;
            }
            catch (const std::exception& e) {
                std::cerr << "Connection attempt failed: " << e.what() << std::endl;
                retryCount++;
                
                if (retryCount < maxRetries) {
                    std::cout << "Retrying in 5 seconds..." << std::endl;
                    std::this_thread::sleep_for(std::chrono::seconds(5));
                }
            }
        }

        if (!connected) {
            throw std::runtime_error("Failed to connect to RabbitMQ after maximum retries");
        }

        std::cout << "Waiting for messages... Press Ctrl+C to exit" << std::endl;

        boost::asio::executor_work_guard<boost::asio::io_context::executor_type> 
            work = boost::asio::make_work_guard(ioContext);

        while (running) {
            ioContext.poll();
            std::this_thread::sleep_for(std::chrono::milliseconds(100));
        }

        return 0;
    }
    catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
}