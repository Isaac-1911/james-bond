@extends('layout')

@section('content')
<div class="page-header">
    <h1 class="search-title">Hasil pencarian: "{{ $q }}"</h1>
</div>

<div class="search-results">
    <!-- News Section -->
    <div class="search-section">
        <h2>📰 News</h2>
        @if($news->count())
            <div class="results-list">
                @foreach($news as $item)
                    <div class="result-card">
                        <a href="/news/{{ $item->news_id }}" class="result-link">{{ $item->title }}</a>
                        <p class="result-meta">{{ \Carbon\Carbon::parse($item->release_date ?? $item->created_at)->format('d M Y') }}</p>
                    </div>
                @endforeach
            </div>
        @else
            <div class="empty-state">
                <p>Tidak ada berita.</p>
            </div>
        @endif
    </div>

    <!-- Infographics Section -->
    <div class="search-section">
        <h2>🖼️ Infographics</h2>
        @if($infographics->count())
            <div class="results-list">
                @foreach($infographics as $item)
                    <div class="result-card">
                        <a href="/infographics/{{ $item->infographic_id }}" class="result-link">{{ $item->title }}</a>
                        @if($item->description)
                            <p class="result-meta">{{ Str::limit($item->description, 100) }}</p>
                        @endif
                    </div>
                @endforeach
            </div>
        @else
            <div class="empty-state">
                <p>Tidak ada infografik.</p>
            </div>
        @endif
    </div>

    <!-- Publications Section -->
    <div class="search-section">
        <h2>📄 Publications</h2>
        @if($publications->count())
            <div class="results-list">
                @foreach($publications as $item)
                    <div class="result-card">
                        <a href="/publications/{{ $item->publication_id }}" class="result-link">{{ $item->title }}</a>
                        <p class="result-meta">{{ \Carbon\Carbon::parse($item->release_date)->format('d M Y') }}</p>
                    </div>
                @endforeach
            </div>
        @else
            <div class="empty-state">
                <p>Tidak ada publikasi.</p>
            </div>
        @endif
    </div>
</div>
@endsection
