<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        User::factory()->create([
            'name' => 'Mas Wowo',
            'email' => 'wowo@toko.com',
        ]);

        User::factory()->create([
            'name' => 'Pak Cokomi',
            'email' => 'cokomi@toko.com',
        ]);

        \App\Models\Product::factory(10)->create();
    }
}
