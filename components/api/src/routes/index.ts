import { Router, Request, Response } from "express";
import db from "../db";

const router = Router();

router.get("/", (req: Request, res: Response) => {
  res.json({ message: "Hello from Express!" });
});

router.get("/health", (req: Request, res: Response) => {
  res.json({ message: "OK" });
});

router.get("/api/v1/messages", async (req: Request, res: Response) => {
  const messages = await db.message.findMany();
  if (!messages) {
    return res.status(404).json({ message: "No messages found" });
  }
  console.info("------------ messages: ", messages);
  res.json({ data: messages, message: "Messages fetched successfully" });
});

router.post("/api/v1/messages", async (req: Request, res: Response) => {
  const { message } = req.body;
  console.info("------------ message: ", message);
  const newMessage = await db.message.create({
    data: {
      content: message,
    },
  });

  if (!newMessage) {
    return res.status(400).json({ message: "Failed to create message" });
  }

  // TODO: Send message to RabbitMQ

  console.info("------------ newMessage Created: ", newMessage);
  res.json({ data: newMessage, message: "Message created successfully" });
});

export default router;
