// ============================================================
//  app.js  –  Portforaisa | TikTok Content Planner
//  Stack  : Node.js + Express + EJS + Bootstrap + jQuery
// ============================================================

const express = require("express");
const bodyParser = require("body-parser");
const path = require("path");
const fs = require("fs");

const kontenRoutes = require("./routes/konten");

const app = express();
const PORT = process.env.PORT || 3000;

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, "public")));

const dataPath = path.join(__dirname, "data", "konten.json");

// ── Routes ───────────────────────────────────────────────────
app.use("/konten", kontenRoutes);

// Dashboard
app.get("/", (req, res) => {
  const raw = fs.existsSync(dataPath)
    ? fs.readFileSync(dataPath, "utf-8")
    : "[]";
  const data = JSON.parse(raw);

  const stats = {
    total: data.length,
    idea: data.filter((k) => k.status === "Idea").length,
    shooting: data.filter((k) => k.status === "Shooting").length,
    editing: data.filter((k) => k.status === "Editing").length,
    ready: data.filter((k) => k.status === "Ready").length,
    posted: data.filter((k) => k.status === "Posted").length,
  };

  // Jadwal terdekat (upcoming, belum posted)
  const now = new Date();
  const upcoming = data
    .filter((k) => k.status !== "Posted" && new Date(k.jadwal) >= now)
    .sort((a, b) => new Date(a.jadwal) - new Date(b.jadwal))
    .slice(0, 5);

  res.render("index", { title: "Dashboard", stats, upcoming });
});

app.listen(PORT, () => {
  console.log(`\n🎬  Portforaisa berjalan di → http://localhost:${PORT}\n`);
});
