@extends('layout')

@section('content')
<div class="bps-container">
    <nav class="bps-breadcrumb">
        <a href="/">Beranda</a> › <span>Publikasi</span>
    </nav>

    <h1 class="bps-title">Publikasi</h1>
    <p class="bps-desc">
        Publikasi statistik yang disusun berdasarkan hasil sensus, survei, dan kegiatan statistik lainnya.
    </p>

    <div class="bps-panel">
        <table class="bps-table">
            <thead>
                <tr>
                    <th>Cover</th>
                    <th>Judul Publikasi</th>
                    <th>Tanggal Rilis</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                @foreach($publications as $pub)
                <tr>
                    <td>
                        <img src="{{ asset($pub->cover_url) }}" alt="Cover {{ $pub->title }}" class="bps-cover-preview">
                    </td>
                    <td>
                        <a href="/publications/{{ $pub->publication_id }}" class="bps-link">{{ $pub->title }}</a>
                        <div class="bps-summary">{{ Str::limit($pub->summary, 120) }}</div>
                    </td>
                    <td>{{ \Carbon\Carbon::parse($pub->release_date)->format('d M Y') }}</td>
                    <td>
                        <a href="{{ asset($pub->file_url) }}" target="_blank" class="bps-btn">Unduh</a>
                    </td>
                </tr>
                @endforeach
            </tbody>
        </table>

        <div class="bps-pagination">
            {{ $publications->links() }}
        </div>
    </div>
</div>
@endsection
