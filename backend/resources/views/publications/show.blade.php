@extends('layout')

@section('content')
<nav class="breadcrumb">
    <a href="/">Beranda</a> ›
    <a href="/publications">Publikasi</a> ›
    <span>{{ $publication->title }}</span>
</nav>

<h1 class="detail-title">{{ $publication->title }}</h1>

<div class="detail-row">
    <div class="detail-cover-col">
        <img src="{{ asset($publication->cover_url) }}" alt="Cover {{ $publication->title }}" class="detail-cover">
        <a href="{{ asset($publication->file_url) }}" target="_blank" class="download-btn">⬇ Unduh Publikasi (PDF)</a>
    </div>

    <div class="detail-meta-col">
        <table class="meta-table">
            <tr>
                <th>Tanggal Rilis</th>
                <td>{{ \Carbon\Carbon::parse($publication->release_date)->format('d F Y') }}</td>
            </tr>
            <tr>
                <th>Kategori</th>
                <td>{{ $publication->publication_category ?? '-' }}</td>
            </tr>
            <tr>
                <th>Bahasa</th>
                <td>Indonesia</td>
            </tr>
        </table>

        <hr class="meta-divider">

        <h4>Abstrak</h4>
        <p class="publication-description">{{ $publication->summary ?? $publication->description }}</p>
    </div>
</div>

<a href="/publications" class="back-link">← Kembali ke Publikasi</a>
@endsection
