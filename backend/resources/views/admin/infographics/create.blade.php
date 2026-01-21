@extends('admin.layout')

@section('content')
<div class="page-header">
    <h1>Tambah Infografis</h1>
</div>

<form action="/admin/infographics" method="POST" enctype="multipart/form-data" class="form-container">
    @csrf

    <div class="form-group">
        <label>Judul</label>
        <input type="text" name="title" value="{{ old('title') }}" placeholder="Masukkan judul infografis" required>
    </div>

    <div class="form-group">
        <label>Deskripsi</label>
        <textarea name="description" rows="4" placeholder="Masukkan deskripsi infografis">{{ old('description') }}</textarea>
    </div>

    <div class="form-group">
        <label>Gambar Infografis</label>
        <input type="file" name="image" accept="image/*" required>
    </div>

    <div class="form-actions">
        <button class="btn btn-primary" type="submit">Simpan</button>
        <a class="btn btn-secondary" href="/admin/infographics">Batal</a>
    </div>
</form>
@endsection
