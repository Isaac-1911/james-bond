@extends('layout')

@section('content')

<div class="page-header">
    <h1 class="page-title">Infographics</h1>
</div>

@if($infographics->isEmpty())
    <div class="empty-state">
        <p>Tidak ada infografik tersedia.</p>
    </div>
@else
    <div class="infographic-grid">
        @foreach($infographics as $item)
            <div class="infographic-card">
                @if($item->image_url)
                    <img src="{{ asset('storage/' . $item->image_url) }}" alt="{{ $item->title }}" class="infographic-thumb">
                @endif
                <h3>{{ $item->title }}</h3>
                <a href="/infographics/{{ $item->infographic_id }}" class="card-link">Lihat Detail →</a>
            </div>
        @endforeach
    </div>
@endif

@endsection
