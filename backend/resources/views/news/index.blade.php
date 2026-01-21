@php use Illuminate\Support\Str; @endphp
@extends('layout')

@section('content')
<div class="page-header">
    <h1 class="page-title">News</h1>
</div>

<div class="news-list">
    @foreach($news as $item)
    <div class="news-card">
        @if($item->image_url)
            <img
  src="{{ Str::startsWith($item->image_url, 'http')
        ? $item->image_url
        : asset('storage/' . $item->image_url) }}"
  alt="{{ $item->title }}"
  class="news-thumb"
>

        @endif

        <div class="news-body">
            <h2>{{ $item->title }}</h2>
            <p class="news-date">
                {{ \Carbon\Carbon::parse($item->release_date ?? $item->created_at)->format('d M Y') }}
            </p>
            <p class="news-summary">
                {{ Str::limit($item->summary, 150) }}
            </p>
            <a href="/news/{{ $item->news_id }}" class="read-more">Baca selengkapnya →</a>
        </div>
    </div>
    @endforeach
</div>

<!-- PAGINATION -->
<div class="pagination">
    {{ $news->links() }}
</div>
@endsection
