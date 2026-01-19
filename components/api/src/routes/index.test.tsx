import request from "supertest";
import express from "express";
import router from "./index";
import db from "../db";

jest.mock("../db", () => ({
  message: {
    findMany: jest.fn(),
    create: jest.fn(),
  },
}));

const app = express();
app.use(express.json());
app.use(router);

describe("Routes", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe("GET /", () => {
    it("should return hello message", async () => {
      const response = await request(app).get("/");

      expect(response.status).toBe(200);
      expect(response.body).toEqual({ message: "Hello from Express!" });
    });
  });

  describe("GET /health", () => {
    it("should return OK status", async () => {
      const response = await request(app).get("/health");

      expect(response.status).toBe(200);
      expect(response.body).toEqual({ message: "OK" });
    });
  });

  describe("GET /api/v1/messages", () => {
    it("should return messages when found", async () => {
      const mockMessages = [
        { id: 1, content: "Test message 1" },
        { id: 2, content: "Test message 2" },
      ];

      (db.message.findMany as jest.Mock).mockResolvedValue(mockMessages);

      const response = await request(app).get("/api/v1/messages");

      expect(response.status).toBe(200);
      expect(response.body).toEqual({
        data: mockMessages,
        message: "Messages fetched successfully",
      });
      expect(db.message.findMany).toHaveBeenCalledTimes(1);
    });

    it("should return 404 when no messages found", async () => {
      (db.message.findMany as jest.Mock).mockResolvedValue(null);

      const response = await request(app).get("/api/v1/messages");

      expect(response.status).toBe(404);
      expect(response.body).toEqual({ message: "No messages found" });
    });

    it("should return empty array when messages is empty", async () => {
      (db.message.findMany as jest.Mock).mockResolvedValue([]);

      const response = await request(app).get("/api/v1/messages");

      expect(response.status).toBe(200);
      expect(response.body).toEqual({
        data: [],
        message: "Messages fetched successfully",
      });
    });
  });

  describe("POST /api/v1/messages", () => {
    it("should create a new message successfully", async () => {
      const mockMessage = { id: 1, content: "New test message" };
      const requestBody = { content: "New test message" };

      (db.message.create as jest.Mock).mockResolvedValue(mockMessage);

      const response = await request(app)
        .post("/api/v1/messages")
        .send(requestBody);

      expect(response.status).toBe(200);
      expect(response.body).toEqual({
        data: mockMessage,
        message: "Message created successfully & published to Core Queue",
      });
      expect(db.message.create).toHaveBeenCalledWith({
        data: {
          content: "New test message",
        },
      });
    });

    it("should return 400 when message creation fails", async () => {
      const requestBody = { content: "Failed message" };

      (db.message.create as jest.Mock).mockResolvedValue(null);

      const response = await request(app)
        .post("/api/v1/messages")
        .send(requestBody);

      expect(response.status).toBe(400);
      expect(response.body).toEqual({ message: "Failed to create message" });
    });

    it("should handle missing content in request body", async () => {
      const mockMessage = { id: 1, content: undefined };

      (db.message.create as jest.Mock).mockResolvedValue(mockMessage);

      const response = await request(app).post("/api/v1/messages").send({});

      expect(response.status).toBe(200);
      expect(db.message.create).toHaveBeenCalledWith({
        data: {
          content: undefined,
        },
      });
    });
  });
});
