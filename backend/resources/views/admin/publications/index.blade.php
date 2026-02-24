@extends('admin.layout')

@section('content')
<div class="page-header">
    <h1>Manajemen Publikasi</h1>
    <a href="/admin/publications/create" class="btn btn-primary add-btn">+ Tambah Publikasi</a>
</div>

@if(session('success'))
    <div class="alert-success">
        {{ session('success') }}
    </div>
@endif

<div class="table-container">
    <table class="data-table">
        <thead>
            <tr>
                <th>Judul</th>
                <th>Tanggal</th>
                <th>Cover</th>
                <th>PDF</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            @foreach($publications as $item)
            <tr>
                <td>{{ $item->title }}</td>
                <td>{{ \Carbon\Carbon::parse($item->release_date)->format('d M Y') }}</td>
                <td>
                    @if($item->cover_url)
                        <img src="{{ asset($item->cover_url) }}" alt="Cover" class="preview-img">
                    @else
                        -
                    @endif
                </td>
                <td>
                    <a href="{{ asset('storage/'.$item->file_url) }}" target="_blank" class="pdf-link">Lihat PDF</a>
                </td>
                <td>
                    <form action="/admin/publications/{{ $item->publication_id }}" method="POST" class="delete-form"
                          onsubmit="return confirm('Hapus publikasi ini?')">
                        @csrf
                        @method('DELETE')
                        <button class="btn btn-danger" type="submit">Hapus</button>
                    </form>
                </td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection
