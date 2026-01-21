@extends('admin.layout')

@section('content')
<div class="page-header">
    <h1>Tambah Data Statistik</h1>
    <p class="page-desc">Tambahkan data statistik baru untuk portal.</p>
</div>

@if ($errors->any())
    <div class="alert-error">
        <ul>
            @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif

<div class="form-card">
    <form action="/admin/statistics" method="POST">
        @csrf

        <div class="form-group">
            <label>Judul Statistik</label>
            <input type="text" name="title" value="{{ old('title') }}" placeholder="Judul statistik" required>
        </div>

        <div class="form-group">
            <label>Kategori</label>
            <select name="category_id" required>
                @foreach($categories as $cat)
                    <option value="{{ $cat->category_id }}" {{ old('category_id') == $cat->category_id ? 'selected' : '' }}>
                        {{ $cat->name }}
                    </option>
                @endforeach
            </select>
        </div>

        <div class="form-group">
            <label>Nilai</label>
            <input type="number" step="any" name="value" value="{{ old('value') }}" placeholder="Masukkan nilai" required>
        </div>

        <div class="form-group">
            <label>Satuan</label>
            <input type="text" name="unit" value="{{ old('unit') }}" placeholder="%, orang, km, dll" required>
        </div>

        <div class="form-group">
            <label>Periode</label>
            <input type="text" name="period" value="{{ old('period') }}" placeholder="2024 / Q1 2024" required>
        </div>

        <div class="form-group">
            <label>Deskripsi (opsional)</label>
            <textarea name="description" rows="4" placeholder="Deskripsi tambahan">{{ old('description') }}</textarea>
        </div>

        <div class="form-actions">
            <button class="btn btn-primary" type="submit">Simpan</button>
            <a class="btn btn-secondary" href="/admin/statistics">Batal</a>
        </div>
    </form>
</div>
@endsection
