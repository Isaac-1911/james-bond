@extends('layout')

@section('content')

<!-- HERO -->
<section class="hero">
    <div class="hero-content">
        <h1>James Bond Data Portal</h1>
        <p>Portal resmi penyajian data, statistik, publikasi, dan informasi terkini dalam satu platform terintegrasi.</p>
    </div>
</section>

<!-- QUICK STATS -->
<section class="stats">
    <div class="stat-box">
        <h2>{{ $statCount }}</h2>
        <p>Data Statistik</p>
    </div>
    <div class="stat-box">
        <h2>{{ $publicationCount }}</h2>
        <p>Publikasi</p>
    </div>
    <div class="stat-box">
        <h2>{{ $newsCount }}</h2>
        <p>Berita</p>
    </div>
</section>

<!-- CONTENT GRID -->
<section class="grid">
    <div class="card">
        <h3>📰 News</h3>
        <p>Berita dan informasi terbaru.</p>
        <a href="/news" class="card-link">Buka News →</a>
    </div>

    <div class="card">
        <h3>🖼️ Infographics</h3>
        <p>Visualisasi data dalam bentuk infografik.</p>
        <a href="/infographics" class="card-link">Lihat Infografik →</a>
    </div>

    <div class="card">
        <h3>📄 Publications</h3>
        <p>Laporan dan dokumen resmi.</p>
        <a href="/publications" class="card-link">Download Publikasi →</a>
    </div>
</section>

<!-- LATEST NEWS -->
<section class="latest-news">
    <h2>📰 Berita Terbaru</h2>
    <div class="news-list">
        @foreach($latestNews as $news)
            <div class="news-row">
                <strong>{{ $news->title }}</strong>
                <small>{{ $news->release_date }}</small>
                <p>{{ $news->summary }}</p>
                <a href="/news/{{ $news->news_id }}" class="news-link">Baca selengkapnya →</a>
            </div>
        @endforeach
    </div>
</section>

@endsection
