import amqp from "amqplib";

async function* fakeLLM(prompt: string) {
  // Stream Fake LLM response
  for (let i = 0; i < 10; i++) {
    await new Promise((resolve) => setTimeout(resolve, 1000));
    yield `This is a fake LLM response ${i + 1}`;
  }
}

async function publishCoreAnswers(prompt: string) {
  const QUEUE_NAME = "answer_queue";
  const connection = await amqp.connect(process.env.RABBITMQ_URL as string);

  console.log("==> Connected to RabbitMQ");
  const channel = await connection.createChannel();
  await channel.assertQueue(QUEUE_NAME, { durable: false });

  for await (const answer of fakeLLM(prompt)) {
    await channel.sendToQueue(QUEUE_NAME, Buffer.from(answer));
    console.log("==> Answer published to queue answers: ", answer);
  }
}

export async function consumeUserPrompts() {
  try {
    const QUEUE_NAME = "prompt_queue";

    const connection = await amqp.connect(process.env.RABBITMQ_URL as string);
    console.log("==> Connected to RabbitMQ");

    const channel = await connection.createChannel();
    await channel.assertQueue(QUEUE_NAME, { durable: false });
    await channel.consume(QUEUE_NAME, async (message) => {
      console.log("==> Prompt consumed: ", message?.content.toString());
      await publishCoreAnswers(message?.content.toString() as string);
      channel.ack(message as amqp.Message);
    });
  } catch (err) {
    console.error("Error consuming queue prompts: ", err);
  }
}
