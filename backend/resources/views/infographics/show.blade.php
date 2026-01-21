@extends('layout')

@section('content')

<article class="infographic-detail">
    @if($infographic->image_url)
        <img src="{{ asset('storage/' . $infographic->image_url) }}" alt="{{ $infographic->title }}" class="infographic-detail-image">
    @endif

    <h1>{{ $infographic->title }}</h1>

    @if($infographic->description)
        <p class="description">{{ $infographic->description }}</p>
    @endif

    <a href="/infographics" class="back-link">← Kembali ke Infographics</a>
</article>

@endsection
