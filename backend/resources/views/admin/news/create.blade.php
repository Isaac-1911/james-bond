@extends('admin.layout')

@section('content')
<div class="page-header">
    <h1>Tambah News</h1>
    <p class="page-desc">Tambahkan berita baru yang akan ditampilkan di portal publik.</p>
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
    <form action="/admin/news" method="POST" enctype="multipart/form-data">
        @csrf

        <div class="form-group">
            <label>Judul</label>
            <input type="text" name="title" placeholder="Judul berita" value="{{ old('title') }}" required>
        </div>

        <div class="form-group">
            <label>Tanggal Rilis</label>
            <input type="date" name="release_date" value="{{ old('release_date') }}" required>
        </div>

        <div class="form-group">
            <label>Ringkasan</label>
            <textarea name="summary" rows="5" placeholder="Ringkasan singkat berita">{{ old('summary') }}</textarea>
        </div>

        <div class="form-group">
            <label>Gambar (opsional)</label>
            <input type="file" name="image" accept="image/*">
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">Simpan</button>
            <a href="/admin/news" class="btn btn-secondary">Batal</a>
        </div>
    </form>
</div>
@endsection
