@extends('admin.layout')

@section('content')
<div class="page-header">
    <h1>Tambah Publikasi</h1>
    <a href="/admin/publications" class="btn btn-secondary">← Kembali</a>
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

<form action="/admin/publications" method="POST" enctype="multipart/form-data" class="form-card">
    @csrf

    {{-- Judul --}}
    <div class="form-group">
        <label>Judul Publikasi</label>
        <input
            type="text"
            name="title"
            value="{{ old('title') }}"
            required
        >
    </div>

    {{-- Tanggal Rilis --}}
    <div class="form-group">
        <label>Tanggal Rilis</label>
        <input
            type="date"
            name="release_date"
            value="{{ old('release_date') }}"
        >
    </div>

    {{-- Ringkasan --}}
    <div class="form-group">
        <label>Ringkasan</label>
        <textarea
            name="summary"
            rows="3"
        >{{ old('summary') }}</textarea>
    </div>

    {{-- Metadata --}}
    <div class="form-grid">
        <div class="form-group">
            <label>Nomor Katalog</label>
            <input
                
                name="catalog_number"
                value="{{ old('catalog_number') }}"
            >
        </div>

        <div class="form-group">
            <label>Nomor Publikasi</label>
            <input
                type="text"
                name="publication_number"
                value="{{ old('publication_number') }}"
            >
        </div>

        <div class="form-group">
            <label>ISBN</label>
            <input
                type="text"
                name="isbn"
                value="{{ old('isbn') }}"
            >
        </div>
    </div>

    {{-- Cover --}}
    <div class="form-group">
        <label>Cover (Opsional)</label>
        <input
            type="file"
            name="cover"
            accept="image/*"
        >
    </div>

    {{-- PDF --}}
    <div class="form-group">
        <label>File PDF</label>
        <input
            type="file"
            name="pdf"
            accept="application/pdf"
            required
        >
    </div>

    {{-- Featured --}}

    {{-- Submit --}}
    <div class="form-actions">
        <button type="submit" class="btn btn-primary">
            Simpan Publikasi
        </button>
    </div>
</form>
@endsection
