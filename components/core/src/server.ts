import express from "express";
import routes from "./routes";
import { consumeUserPrompts } from "./queue";

const app = express();
const PORT = process.env.PORT || 3002;

// Middleware
app.use(express.json());

// Routes
app.use("/", routes);

// Start server
app.listen(PORT, async () => {
  console.log(`🚀 Express server running at http://localhost:${PORT}`);

  await consumeUserPrompts();
});
