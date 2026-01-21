@extends('admin.layout')

@section('content')
<div class="page-header">
    <h1>Tambah Publikasi</h1>
    <p class="page-desc">Tambahkan data publikasi beserta file PDF dan cover (opsional).</p>
</div>

{{-- ERROR VALIDATION --}}
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
    <form action="/admin/publications" method="POST" enctype="multipart/form-data">
        @csrf

        <div class="form-group">
            <label>Judul</label>
            <input type="text" name="title" value="{{ old('title') }}" placeholder="Judul publikasi" required>
        </div>

        <div class="form-group">
            <label>Tanggal Rilis</label>
            <input type="date" name="release_date" value="{{ old('release_date') }}" required>
        </div>

        <div class="form-group">
            <label>Ringkasan</label>
            <textarea name="summary" rows="5" placeholder="Ringkasan singkat publikasi">{{ old('summary') }}</textarea>
        </div>

        <div class="form-group">
            <label>Cover (opsional)</label>
            <input type="file" name="cover" accept="image/*">
        </div>

        <div class="form-group">
            <label>File PDF</label>
            <input type="file" name="pdf" accept="application/pdf" required>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">Simpan</button>
            <a href="/admin/publications" class="btn btn-secondary">Batal</a>
        </div>
    </form>
</div>
@endsection
