<?php
$mahasiswa = [
    [
        "nama"        => "Zayn Malik",
        "nim"         => "1111111",
        "nilai_tugas" => 80,
        "nilai_uts"   => 80,
        "nilai_uas"   => 80,
    ],
    [
        "nama"        => "Frank Ocean",
        "nim"         => "2222222",
        "nilai_tugas" => 70,
        "nilai_uts"   => 75,
        "nilai_uas"   => 70,
    ],
    [
        "nama"        => "Raifanka Raisa Ramadhan",
        "nim"         => "3333333",
        "nilai_tugas" => 100,
        "nilai_uts"   => 100,
        "nilai_uas"   => 100,
    ],
    [
        "nama"        => "SZA",
        "nim"         => "4444444",
        "nilai_tugas" => 80,
        "nilai_uts"   => 100,
        "nilai_uas"   => 100,
    ],
    [
        "nama"        => "Jeremy Zucker",
        "nim"         => "5555555",
        "nilai_tugas" => 90,
        "nilai_uts"   => 90,
        "nilai_uas"   => 75,
    ],
];

// Bobot: Tugas 30%, UTS 30%, UAS 40%
function hitungNilaiAkhir($tugas, $uts, $uas) {
    return round(($tugas * 0.30) + ($uts * 0.30) + ($uas * 0.40), 2);
}

function tentukanGrade($nilaiAkhir) {
    if ($nilaiAkhir >= 85) {
        return "A";
    } elseif ($nilaiAkhir >= 75) {
        return "B";
    } elseif ($nilaiAkhir >= 65) {
        return "C";
    } elseif ($nilaiAkhir >= 55) {
        return "D";
    } else {
        return "E";
    }
}

function tentukanStatus($nilaiAkhir) {
    if ($nilaiAkhir >= 60) {
        return "Lulus";
    } else {
        return "Tidak Lulus";
    }
}

$totalNilai     = 0;
$nilaiTertinggi = 0;
$namaTertinggi  = "";
$hasilData      = [];

foreach ($mahasiswa as $mhs) {
    $nilaiAkhir = hitungNilaiAkhir($mhs["nilai_tugas"], $mhs["nilai_uts"], $mhs["nilai_uas"]);
    $grade      = tentukanGrade($nilaiAkhir);
    $status     = tentukanStatus($nilaiAkhir);

    $totalNilai += $nilaiAkhir;

    if ($nilaiAkhir > $nilaiTertinggi) {
        $nilaiTertinggi = $nilaiAkhir;
        $namaTertinggi  = $mhs["nama"];
    }

    $hasilData[] = [
        "nama"        => $mhs["nama"],
        "nim"         => $mhs["nim"],
        "nilai_tugas" => $mhs["nilai_tugas"],
        "nilai_uts"   => $mhs["nilai_uts"],
        "nilai_uas"   => $mhs["nilai_uas"],
        "nilai_akhir" => $nilaiAkhir,
        "grade"       => $grade,
        "status"      => $status,
    ];
}

$rataRata = round($totalNilai / count($mahasiswa), 2);
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Sistem Penilaian Mahasiswa</title>
</head>
<body>

<h2>Sistem Penilaian Mahasiswa</h2>
<p>Bobot Nilai: Tugas 30% | UTS 30% | UAS 40%</p>

<table border="1" cellpadding="8" cellspacing="0">
    <thead>
        <tr>
            <th>No</th>
            <th>Nama</th>
            <th>NIM</th>
            <th>Tugas</th>
            <th>UTS</th>
            <th>UAS</th>
            <th>Nilai Akhir</th>
            <th>Grade</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody>
        <?php
        $no = 1;
        foreach ($hasilData as $row):
        ?>
        <tr>
            <td><?= $no++ ?></td>
            <td><?= htmlspecialchars($row["nama"]) ?></td>
            <td><?= htmlspecialchars($row["nim"]) ?></td>
            <td><?= $row["nilai_tugas"] ?></td>
            <td><?= $row["nilai_uts"] ?></td>
            <td><?= $row["nilai_uas"] ?></td>
            <td><?= $row["nilai_akhir"] ?></td>
            <td><?= $row["grade"] ?></td>
            <td><?= $row["status"] ?></td>
        </tr>
        <?php endforeach; ?>
    </tbody>
</table>

<p><strong>Rata-rata Kelas : <?= $rataRata ?></strong></p>
<p><strong>Nilai Tertinggi : <?= $nilaiTertinggi ?> (<?= $namaTertinggi ?>)</strong></p>

</body>
</html>