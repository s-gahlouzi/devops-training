import express from "express";
import routes from "./routes";
import { consumeCoreAnswers } from "./queue/consumer";

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Routes
app.use("/", routes);

// Start server
app.listen(PORT, async () => {
  console.log(`🚀 Express server running at http://localhost:${PORT}`);

  await consumeCoreAnswers();
});
