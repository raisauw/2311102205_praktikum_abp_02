const express = require("express");
const router = express.Router();
const fs = require("fs");
const path = require("path");

const dataPath = path.join(__dirname, "..", "data", "konten.json");

function readData() {
  return JSON.parse(fs.readFileSync(dataPath, "utf-8"));
}
function writeData(data) {
  fs.writeFileSync(dataPath, JSON.stringify(data, null, 2));
}
function generateId() {
  return "ktk-" + Date.now();
}

// ── [READ] Halaman tabel ─────────────────────────────────────
router.get("/", (req, res) => {
  res.render("konten/index", { title: "Content Planner" });
});

// ── [API] JSON untuk DataTables ──────────────────────────────
router.get("/api/data", (req, res) => {
  const data = readData();
  res.json({ data });
});

// ── [CREATE] Form tambah ─────────────────────────────────────
router.get("/tambah", (req, res) => {
  res.render("konten/form", {
    title: "Tambah Konten",
    action: "tambah",
    konten: null,
  });
});

// ── [CREATE] Simpan ──────────────────────────────────────────
router.post("/tambah", (req, res) => {
  const { judul, jadwal, linkBarang, status } = req.body;
  const data = readData();

  const baru = {
    id: generateId(),
    judul: judul.trim(),
    jadwal: jadwal,
    linkBarang: linkBarang ? linkBarang.trim() : "",
    status: status,
    createdAt: new Date().toISOString(),
  };

  data.push(baru);
  writeData(data);

  res.json({
    success: true,
    message: `Konten "${baru.judul}" berhasil ditambahkan!`,
    data: baru,
  });
});

// ── [UPDATE] Form edit ───────────────────────────────────────
router.get("/edit/:id", (req, res) => {
  const data = readData();
  const konten = data.find((k) => k.id === req.params.id);
  if (!konten) return res.redirect("/konten");
  res.render("konten/form", { title: "Edit Konten", action: "edit", konten });
});

// ── [UPDATE] Proses update ───────────────────────────────────
router.post("/edit/:id", (req, res) => {
  const { judul, jadwal, linkBarang, status } = req.body;
  const data = readData();
  const index = data.findIndex((k) => k.id === req.params.id);

  if (index === -1)
    return res.json({ success: false, message: "Data tidak ditemukan!" });

  data[index] = {
    ...data[index],
    judul: judul.trim(),
    jadwal: jadwal,
    linkBarang: linkBarang ? linkBarang.trim() : "",
    status: status,
    updatedAt: new Date().toISOString(),
  };

  writeData(data);
  res.json({
    success: true,
    message: `Konten "${data[index].judul}" berhasil diperbarui!`,
    data: data[index],
  });
});

// ── [DELETE] Hapus ───────────────────────────────────────────
router.delete("/hapus/:id", (req, res) => {
  const data = readData();
  const index = data.findIndex((k) => k.id === req.params.id);

  if (index === -1)
    return res.json({ success: false, message: "Data tidak ditemukan!" });

  const judul = data[index].judul;
  data.splice(index, 1);
  writeData(data);

  res.json({ success: true, message: `Konten "${judul}" berhasil dihapus!` });
});

// ── [API] Detail satu konten ─────────────────────────────────
router.get("/detail/:id", (req, res) => {
  const data = readData();
  const konten = data.find((k) => k.id === req.params.id);
  if (!konten)
    return res.json({ success: false, message: "Data tidak ditemukan!" });
  res.json({ success: true, data: konten });
});

module.exports = router;
