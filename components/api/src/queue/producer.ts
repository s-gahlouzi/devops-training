import amqp from "amqplib";

export async function publishUserPrompts(prompt: string) {
  try {
    const QUEUE_NAME = "prompt_queue";

    // Connect to RabbitMQ
    const connection = await amqp.connect(process.env.RABBITMQ_URL as string);
    console.log("==> Connected to RabbitMQ");

    // Create a channel
    const channel = await connection.createChannel();
    // Assert the queue
    await channel.assertQueue(QUEUE_NAME, { durable: false });

    // Send the message to the queue
    await channel.sendToQueue(QUEUE_NAME, Buffer.from(prompt));

    console.log("==> Message published to queue prompts: ", prompt);
  } catch (err) {
    console.error("Error publishing queue prompts: ", err);
  }
}
