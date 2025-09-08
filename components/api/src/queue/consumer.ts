import amqp from "amqplib";

export async function consumeCoreAnswers() {
  try {
    const QUEUE_NAME = "answer_queue";

    const connection = await amqp.connect(process.env.RABBITMQ_URL as string);
    console.log("==> Connected to RabbitMQ");
    // Create a channel
    const channel = await connection.createChannel();
    // Assert the queue
    await channel.assertQueue(QUEUE_NAME, { durable: false });

    // Consume the queue
    await channel.consume(QUEUE_NAME, (message) => {
      console.log("==> Message received: ", message?.content.toString());

      // TODO: Send the answer to the frontend via http stream

      // Acknowledge the message
      channel.ack(message as amqp.Message);
    });
  } catch (err) {
    console.error("Error consuming queue answers: ", err);
  }
}
