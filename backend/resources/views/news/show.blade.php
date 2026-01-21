@extends('layout')

@section('content')
<article class="news-detail">
    <h1 class="news-title">{{ $news->title }}</h1>

    <p class="news-meta">
        Dipublikasikan: {{ \Carbon\Carbon::parse($news->release_date)->format('d M Y') }}
    </p>

    @if($news->image_url)
    <img
  src="{{ Str::startsWith($news->image_url, 'http')
        ? $news->image_url
        : asset('storage/' . $news->image_url) }}"
  alt="{{ $news->title }}"
  class="news-thumb"
>

@endif

    @if($news->summary)
        <div class="news-summary">
            {{ $news->summary }}
        </div>
    @endif

    <a href="/news" class="back-link">← Kembali ke News</a>
</article>
@endsection
